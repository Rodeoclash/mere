defmodule Mere.Interactors.StoreChannelForUsername do
  alias Mere.{
    Repo,
    YouTubeChannels,
  }

  def perform(user_identity, youtube_channel) do
    with {:ok, response} <-
           YouTubeChannels.YouTube.PlaylistItems.for_youtube_channel(user_identity, youtube_channel),
         {:ok, playlist_items} <-
           Repo.insert(%YouTubePlaylistItem{
             body: response.body,
             last_refreshed_at: DateTime.utc_now() |> DateTime.truncate(:second),
             youtube_channel_id: youtube_channel.id
           }),
         do: {:ok, channel}
  end
end
