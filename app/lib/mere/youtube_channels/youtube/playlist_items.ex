defmodule Mere.YouTubeChannels.YouTube.PlaylistItems do
  alias Mere.{
    Repo,
    UserIdentities,
    YouTube,
    YouTubeChannels
  }

  def for_youtube_channel(youtube_channel) do
    youtube_channel = Repo.preload(youtube_channel, :user_identity)

    UserIdentities.YouTube.Client.new(youtube_channel.user_identity)
    |> YouTube.Api.PlaylistItems.list(%{
      "playlistId" => YouTubeChannels.uploadPlaylistId(youtube_channel)
    })
  end
end
