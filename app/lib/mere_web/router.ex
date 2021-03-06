defmodule MereWeb.Router do
  use MereWeb, :router
  use Pow.Phoenix.Router
  use PowAssent.Phoenix.Router

  use Pow.Extension.Phoenix.Router,
    extensions: [PowPersistentSession]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MereWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :pow_assent_persistent_session

    plug PowAssent.Plug.Reauthorization,
      handler: PowAssent.Phoenix.ReauthorizationPlugHandler

    plug MereWeb.CurrentCustomDomainPlug
    plug MereWeb.CurrentSubdomainPlug
    plug MereWeb.UserFromDomainsPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler

    plug MereWeb.CurrentUserPlug
  end

  pipeline :skip_csrf_protection do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
  end

  scope "/", MereWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/privacy", PageController, :privacy
    get "/terms", PageController, :terms
  end

  scope "/admin", MereWeb do
    pipe_through [:browser, :protected]

    resources "/current_user", CurrentUserController, only: [:edit, :update], singleton: true
    resources "/custom_domains", CustomDomainController, only: [:index, :create, :delete]

    live "/youtube/edit", CurrentUserLive.Youtube, :edit
  end

  scope "/" do
    pipe_through :browser

    get "/session/new", MereWeb.RedirectNewSessionPlug, []

    pow_assent_routes()
    pow_session_routes()
    pow_extension_routes()
  end

  scope "/" do
    pipe_through :skip_csrf_protection

    pow_assent_authorization_post_callback_routes()
  end

  # Other scopes may use custom stacks.
  # scope "/api", MereWeb do
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
      live_dashboard "/dashboard", metrics: MereWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  defp pow_assent_persistent_session(conn, _opts) do
    PowAssent.Plug.put_create_session_callback(conn, fn conn, _provider, _config ->
      PowPersistentSession.Plug.create(conn, Pow.Plug.current_user(conn))
    end)
  end
end
