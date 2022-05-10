defmodule ExMonApiWeb.WelcomeController do
  use ExMonApiWeb, :controller

  def index(conn, _params) do
    IO.inspect(conn)
    text(conn, "Welcome to the ExMon API!")
  end
end
