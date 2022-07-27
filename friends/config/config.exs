import Config

config :friends, Friends.Repo,
  database: "friends_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :friends, ecto_repos: [Friends.Repo]


config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase
