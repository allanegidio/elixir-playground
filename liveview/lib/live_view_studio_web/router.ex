defmodule LiveViewStudioWeb.Router do
  use LiveViewStudioWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LiveViewStudioWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LiveViewStudioWeb do
    pipe_through :browser

    live "/", PageLive

    # Aprendendo como disparar eventos e controlar o estado.
    live "/light", LightLive

    # Aprendendo sobre Dynamic Form, eu atualizo o formulario e calculo o valor dos assentos com base no form.
    live "/license", LicenseLive

    # Aprendendo manipular eventos com mensagens internas, dessa forma o estado e atualizado com um worker.
    live "/sales-dashboard", SalesDashboardLive

    # Aprendendo como fazer pesquisas em Live View
    live "/search", SearchLive

    # Aprendendo como fazer autocomplete
    live "/flights", FlightsLive
    live "/autocomplete", AutocompleteLive

    # Aprendendo como fazer filtros.
    live "/filter", FilterLive
    live "/git-repos", GitReposLive

    # Aprendendo como fazer um Formulario com multiplas etapas
    live "/multi-step-form", OrganizationLive

    # Aprendendo sobre live navigation, live_patch vs live_redirect
    live "/servers", ServersLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", LiveViewStudioWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: LiveViewStudioWeb.Telemetry
    end
  end
end
