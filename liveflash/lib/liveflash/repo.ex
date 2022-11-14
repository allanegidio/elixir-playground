defmodule Liveflash.Repo do
  use Ecto.Repo,
    otp_app: :liveflash,
    adapter: Ecto.Adapters.Postgres
end
