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
    |> render("index.html")
  end

  # User homepage
  def index(
        %{assigns: %{user: user, subdomain: subdomain, custom_domain: custom_domain}} = conn,
        _params
      ) do
    youtube_channel =
      YouTubeChannel.where_user_id_query(user.id)
      |> Repo.one()
      |> Repo.preload(youtube_playlist_items: YouTubePlaylistItem.public_videos_query())

    title = youtube_channel.body["brandingSettings"]["channel"]["title"]
    description = youtube_channel.body["snippet"]["description"]

    url =
      cond do
        custom_domain != nil ->
          "https://#{custom_domain.hostname}"

        subdomain != nil ->
          "https://#{subdomain}.#{MereWeb.Endpoint.config(:url)[:host]}"
      end

    conn
    |> put_root_layout(false)
    |> put_layout(false)
    |> assign(:youtube_channel, youtube_channel)
    |> assign(:title, title)
    |> assign(:description, description)
    |> assign(:url, url)
    |> render("user.html")
  end

  def privacy(conn, _params) do
    conn
    |> render("privacy.html")
  end

  def terms(conn, _params) do
    conn
    |> render("terms.html")
  end
end
