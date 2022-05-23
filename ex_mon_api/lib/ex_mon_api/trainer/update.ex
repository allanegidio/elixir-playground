defmodule ExMonApi.Trainer.Update do
  alias ExMonApi.{Trainer, Repo}

  def call(%{"id" => id} = params) do
    case ExMonApi.fetch_trainer(id) do
      {:error, reason} -> {:error, reason}
      {:ok, trainer} -> update_trainer(trainer, params)
    end
  end

  defp update_trainer(trainer, params) do
    trainer
    |> Trainer.changeset(params)
    |> Repo.update()
  end
end
