defmodule Playground.Behaviors.Calculation do
  @callback sum(a :: integer(), b :: integer()) ::
              {:ok, result :: integer()} | {:error, reason :: binary()}

  @callback subtract(a :: integer(), b :: integer()) ::
              {:ok, result :: integer()} | {:error, reason :: binary()}
end
