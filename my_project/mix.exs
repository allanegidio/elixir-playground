defmodule MyProject.MixProject do
  use Mix.Project

  def project do
    [
      app: :my_project,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:ecto, "~> 2.0"},
      {:plug, github: "elixir-lang/plug"},
      {:floki, "~> 0.32.1", only: [:dev]}
    ]
  end

  defp aliases do
    [
      c: "compile",
      hello: &hello/1,
      all: [&hello/1, "deps.get --only #{Mix.env()}", "compile"]
    ]
  end

  defp hello(_) do
    Mix.shell().info("Hello world")
  end
end
