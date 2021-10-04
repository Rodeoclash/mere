defmodule Mere.Interactors.StoreChannelMine do
  alias Mere.{
    Repo,
    YouTubeChannels.YouTubeChannel,
    UserIdentities
  }

  def perform(user_identity) do
    with {:ok, response} <- UserIdentities.YouTube.Channel.mine(user_identity),
         {:ok, channel} <-
           Repo.insert(%YouTubeChannel{
             body: response.body,
             last_refreshed_at: DateTime.utc_now() |> DateTime.truncate(:second),
             mine: true,
             user_identity_id: user_identity.id
           }),
         do: {:ok, channel}
  end
end
