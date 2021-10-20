defmodule MereWeb.UserFromDomainsPlug do
  alias Mere.{
    Repo,
    Users.User
  }

  import Plug.Conn

  def init(default), do: default

  def call(%{assigns: %{subdomain: nil, custom_domain: nil}} = conn, _) do
    conn
    |> assign(:user, nil)
  end

  def call(%{assigns: %{subdomain: "www", custom_domain: nil}} = conn, _) do
    conn
    |> assign(:user, nil)
  end

  def call(%{assigns: %{subdomain: subdomain, custom_domain: nil}} = conn, _) do
    case Repo.get_by(User, %{slug: subdomain}) do
      nil ->
        conn
        |> assign(:user, nil)

      user ->
        conn
        |> assign(:user, user)
    end
  end

  def call(%{assigns: %{subdomain: _subdomain, custom_domain: custom_domain}} = conn, _) do
    custom_domain = Repo.preload(custom_domain, :user)

    conn
    |> assign(:user, custom_domain.user)
  end
end
