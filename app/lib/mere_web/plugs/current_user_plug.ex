defmodule MereWeb.Plugs.CurrentUserPlug do
  alias Mere.{
    Repo
  }

  import Plug.Conn

  def init(default), do: default

  def call(conn, _) do
    current_user =
      Pow.Plug.current_user(conn)
      |> Repo.reload()

    conn
    |> put_session(:current_user_id, current_user.id)
    |> assign(:current_user, current_user)
  end
end
