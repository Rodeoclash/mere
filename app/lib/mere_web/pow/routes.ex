defmodule MereWeb.Pow.Routes do
  alias MereWeb.Router.Helpers, as: Routes
  use Pow.Phoenix.Routes

  def after_sign_in_path(conn), do: Routes.settings_youtube_path(conn, :index)
end
