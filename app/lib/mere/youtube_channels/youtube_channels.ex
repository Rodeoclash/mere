defmodule Mere.YouTubeChannels do
  @topic "youtube_channels"

  def uploadPlaylistId(youtube_channel) do
    youtube_channel.body["contentDetails"]["relatedPlaylists"]["uploads"]
  end

  def subscribe() do
    Phoenix.PubSub.subscribe(Mere.PubSub, @topic)
  end

  def notify_subscribers(youtube_channel, event) do
    Phoenix.PubSub.broadcast(
      Mere.PubSub,
      @topic,
      {__MODULE__, event, youtube_channel}
    )

    {:ok, youtube_channel}
  end
end
