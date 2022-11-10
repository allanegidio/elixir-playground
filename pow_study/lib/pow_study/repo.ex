defmodule PowStudy.Repo do
  use Ecto.Repo,
    otp_app: :pow_study,
    adapter: Ecto.Adapters.Postgres
end
