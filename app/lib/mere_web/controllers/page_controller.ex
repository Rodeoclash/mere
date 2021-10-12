defmodule MereWeb.PageController do
  use MereWeb, :controller

  # Marketing homepage
  def index(%{assigns: %{youtube_channel: nil}} = conn, _params) do
    conn
    |> render("index.html")
  end

  # Channel homepage
  def index(%{assigns: %{youtube_channel: youtube_channel}} = conn, _params) do
    IO.inspect(youtube_channel)

    conn
    |> render("youtube_channel.html")
  end
end
