import Config

config :my_project, :user_name, System.fetch_env!("USER")
