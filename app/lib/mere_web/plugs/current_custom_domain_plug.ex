defmodule MereWeb.CurrentCustomDomainPlug do
  import Plug.Conn

  require Logger

  def init(default), do: default

  def call(conn, _) do
    Logger.info("=== conn host")
    Logger.info(conn.host)
    conn
  end
end
