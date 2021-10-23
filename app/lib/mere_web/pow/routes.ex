defmodule MereWeb.Pow.Routes do
  alias MereWeb.Router.Helpers, as: Routes
  use Pow.Phoenix.Routes

  def after_sign_in_path(conn), do: Routes.current_user_path(conn, :edit)
end
