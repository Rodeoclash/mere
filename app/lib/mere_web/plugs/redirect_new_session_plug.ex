defmodule MereWeb.RedirectNewSessionPlug do
  import Plug.Conn
  import MereWeb.Router.Helpers

  def init(default), do: default

  def call(conn, _opts) do
    conn
    |> Phoenix.Controller.redirect(to: page_path(conn, :index))
    |> halt()
  end
end
