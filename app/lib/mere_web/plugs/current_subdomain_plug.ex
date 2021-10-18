defmodule MereWeb.CurrentSubdomainPlug do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _) do
    case get_subdomain(conn.host) do
      subdomain when byte_size(subdomain) > 0 ->
        conn
        |> assign(:subdomain, subdomain)

      _ ->
        conn
        |> assign(:subdomain, nil)
    end
  end

  defp get_subdomain(host) do
    root_host = MereWeb.Endpoint.config(:url)[:host]
    String.replace(host, ~r/.?#{root_host}/, "")
  end
end
