defmodule ExMonApiWeb.Auth.ErrorHandler do
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  def auth_error(conn, {type, _reason}, _opts) do
    {:ok, body} = Jason.encode(%{message: to_string(type)})

    send_resp(conn, 401, body)
  end
end
