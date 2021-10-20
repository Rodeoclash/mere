defmodule MereWeb.CurrentCustomDomainPlug do
  alias Mere.{
    CustomDomains.CustomDomain,
    Repo
  }

  import Plug.Conn

  require Logger

  def init(default), do: default

  def call(%{host: hostname} = conn, _) do
    cond do
      hostname == "socialeeyes.com" ->
        conn
        |> assign(:custom_domain, nil)

      hostname == "www.socialeeyes.com" ->
        conn
        |> assign(:custom_domain, nil)

      true ->
        case Repo.get_by(CustomDomain, %{hostname: hostname}) do
          nil ->
            conn
            |> assign(:custom_domain, nil)

          custom_domain ->
            conn
            |> assign(:custom_domain, custom_domain)
        end
    end
  end
end
