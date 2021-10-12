defmodule MereWeb.Plugs.UserFromSubdomain do
  alias Mere.{
    Repo,
    Users.User
  }

  import Plug.Conn

  def init(default), do: default

  def call(%{assigns: %{subdomain: nil}} = conn, _) do
    conn
    |> assign(:user, nil)
  end

  def call(%{assigns: %{subdomain: "www"}} = conn, _) do
    conn
    |> assign(:user, nil)
  end

  def call(%{assigns: %{subdomain: subdomain}} = conn, _) do
    case Repo.get_by(User, %{slug: subdomain}) do
      nil ->
        conn
        |> assign(:user, nil)

      user ->
        conn
        |> assign(:user, user)
    end
  end
end
