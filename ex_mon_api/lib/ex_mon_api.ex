defmodule ExMonApi do
  alias ExMonApi.Trainer

  defdelegate create_trainer(params), to: Trainer.Create, as: :call
end
