defmodule Mere.YouTubeChannels do
  def uploadPlaylistId(youtube_channel) do
    item = youtube_channel.body["items"]
           |> List.first()

    item["contentDetails"]["relatedPlaylists"]["uploads"]
  end
end
