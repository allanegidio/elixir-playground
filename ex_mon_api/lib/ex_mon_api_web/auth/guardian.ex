defmodule ExMonApiWeb.Auth.Guardian do
  use Guardian, otp_app: :ex_mon_api

  alias ExMonApi.Trainer

  def subject_for_token(trainer, _claims) do
    sub = to_string(trainer.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    claims
    |> Map.get("sub")
    |> ExMonApi.fetch_trainer()
  end

  def authenticate(%{"id" => trainer_id, "password" => password}) do
    case ExMonApi.fetch_trainer(trainer_id) do
      {:error, reason} -> {:error, reason}
      {:ok, trainer} -> validate_password(trainer, password)
    end
  end

  defp validate_password(%Trainer{password_hash: hash} = trainer, password) do
    case Argon2.verify_pass(password, hash) do
      true -> create_token(trainer)
      false -> {:error, :unauthorized}
    end
  end

  defp create_token(trainer) do
    {:ok, token, _claims} = encode_and_sign(trainer)
    {:ok, token}
  end
end
