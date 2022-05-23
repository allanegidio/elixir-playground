defmodule ExMonApi.Trainer.Delete do
  alias ExMonApi.Repo

  def call(id) do
    case ExMonApi.fetch_trainer(id) do
      {:error, reason} -> {:error, reason}
      {:ok, trainer} -> delete(trainer)
    end
  end

  defp delete(trainer), do: Repo.delete(trainer)
end
