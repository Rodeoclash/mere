defmodule MereWeb.PageController do
  alias Mere.{
    Repo,
    YouTubeChannels.YouTubeChannel,
    YouTubePlaylistItems.YouTubePlaylistItem
  }

  use MereWeb, :controller

  # Marketing homepage
  def index(%{assigns: %{user: nil}} = conn, _params) do
    conn
    |> put_layout("home.html")
    |> render("index.html")
  end

  # User homepage
  def index(%{assigns: %{user: user}} = conn, _params) do
    youtube_channel =
      YouTubeChannel.where_user_id_query(user.id)
      |> Repo.one()
      |> Repo.preload(youtube_playlist_items: YouTubePlaylistItem.public_videos_query())

    conn
    |> put_layout("user.html")
    |> assign(:youtube_channel, youtube_channel)
    |> render("user.html")
  end
end
