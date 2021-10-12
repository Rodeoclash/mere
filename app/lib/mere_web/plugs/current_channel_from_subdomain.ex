defmodule MereWeb.Plugs.CurrentChannelFromSubdomain do
  alias Mere.{
    Repo,
    YouTubeChannels.YouTubeChannel
  }

  import Plug.Conn

  def init(default), do: default

  def call(%{assigns: %{subdomain: nil}} = conn, _) do
    conn
    |> assign(:youtube_channel, nil)
  end

  def call(%{assigns: %{subdomain: subdomain}} = conn, _) do
    case Repo.get_by(YouTubeChannel, %{slug: subdomain}) do
      nil ->
        conn
        |> assign(:youtube_channel, nil)

      youtube_channel ->
        conn
        |> assign(:youtube_channel, youtube_channel)
    end
  end
end
