defmodule Mere.Interactors.StoreChannel do
  alias Mere.{
    Repo,
    YouTubeChannels.YouTubeChannel,
    UserIdentities
  }

  def perform(user_identity) do
    with {:ok, response} <- UserIdentities.YouTube.Channel.mine(user_identity),
         {:ok, channels} <-
           Enum.map(response.body["items"], fn channel ->
             Repo.insert(
               %YouTubeChannel{
                 body: channel,
                 youtube_id: channel["id"],
                 last_refreshed_at: DateTime.utc_now() |> DateTime.truncate(:second),
                 user_identity_id: user_identity.id
               },
               on_conflict: {:replace_all_except, [:id, :youtube_id]},
               conflict_target: :youtube_id
             )
           end),
         do: {:ok, channels}
  end
end
