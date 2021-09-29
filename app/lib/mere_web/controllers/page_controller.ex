defmodule MereWeb.PageController do
  use MereWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
