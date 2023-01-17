defmodule AncestryPoc.Repo do
  use Ecto.Repo,
    otp_app: :ancestry_poc,
    adapter: Ecto.Adapters.Postgres
end
