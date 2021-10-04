defmodule Mere.YouTubeChannels do
  def uploadPlaylistId(youtube_channel) do
    youtube_channel.body["contentDetails"]["relatedPlaylists"]["uploads"]
  end
end
