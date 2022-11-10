defmodule PowStudyWeb.PageController do
  use PowStudyWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
