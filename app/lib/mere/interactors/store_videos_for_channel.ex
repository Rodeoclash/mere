defmodule Mere.Interactors.StoreVideosForChannel do
  alias Mere.{
    Repo,
    YouTubeChannels,
    YouTubePlaylistItems.YouTubePlaylistItem
  }

  def perform(youtube_channel) do
    with {:ok, response} <-
           YouTubeChannels.YouTube.PlaylistItems.for_youtube_channel(youtube_channel),
         _ <- IO.inspect(response),
         {:ok, playlist_items} <-
           Enum.map(response.body["items"], fn playlist_item ->
             Repo.insert(
               %YouTubePlaylistItem{
                 body: playlist_item,
                 youtube_id: playlist_item["id"],
                 last_refreshed_at: DateTime.utc_now() |> DateTime.truncate(:second),
                 youtube_channel_id: youtube_channel.id
               },
               on_conflict: {:replace_all_except, [:id, :youtube_id]},
               conflict_target: :youtube_id
             )
           end),
         do: {:ok, playlist_items}
  end
end
