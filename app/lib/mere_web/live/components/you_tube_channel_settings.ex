defmodule MereWeb.Components.YouTubeChannelSettings do
  alias Mere.{
    Repo,
    YouTubeChannels.YouTubeChannel,
    YouTubePlaylistItems.YouTubePlaylistItem
  }

  use MereWeb, :live_component

  @impl true
  def preload(list_of_assigns) do
    ids = Enum.map(list_of_assigns, & &1.id)

    youtube_channels =
      YouTubeChannel.where_ids_query(ids)
      |> Repo.all()
      |> Repo.preload(youtube_playlist_items: YouTubePlaylistItem.preload_settings_query())
      |> Map.new(fn youtube_channel ->
        {youtube_channel.id, youtube_channel}
      end)

    Enum.map(list_of_assigns, fn assigns ->
      Map.put(assigns, :youtube_channel, youtube_channels[assigns.id])
    end)
  end
end
