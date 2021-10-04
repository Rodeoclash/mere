defmodule Mere.Interactors.StoreChannelForUsername do
  alias Mere.{
    Repo,
    YouTubeChannels.YouTubeChannel,
    UserIdentities
  }

  def perform(user_identity, username) do
    with {:ok, response} <-
           UserIdentities.YouTube.Channel.for_username(user_identity, username),
         {:ok, channel} <-
           Repo.insert(%YouTubeChannel{
             body: response.body,
             last_refreshed_at: DateTime.utc_now() |> DateTime.truncate(:second),
             mine: false,
             user_identity_id: user_identity.id
           }),
         do: {:ok, channel}
  end
end
