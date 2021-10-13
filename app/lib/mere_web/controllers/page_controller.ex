defmodule MereWeb.PageController do
  alias Mere.{
    Repo
  }

  use MereWeb, :controller

  # Marketing homepage
  def index(%{assigns: %{user: nil}} = conn, _params) do
    conn
    |> render("index.html")
  end

  # User homepage
  def index(%{assigns: %{user: user}} = conn, _params) do
    user = Repo.preload(user, youtube_channels: :youtube_playlist_items)
    user_identity = List.first(user.user_identities)
    youtube_channel = List.first(user_identity.youtube_channels)

    IO.inspect(youtube_channel)

    conn
    |> put_layout("user.html")
    |> assign(:youtube_channel, youtube_channel)
    |> render("user.html")
  end
end
