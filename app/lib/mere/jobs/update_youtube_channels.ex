defmodule Mere.Jobs.UpdateYouTubeChannels do
  alias Mere.{
    Jobs,
    Repo,
    UserIdentities,
    UserIdentities.UserIdentity,
    UserIdentities.YouTube,
    YouTubeChannels.YouTubeChannel
  }

  require Logger

  use Oban.Worker, queue: :update_youtube_channel

  @job_name inspect(__MODULE__)

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"id" => id}}) do
    Logger.info("[JOB] Starting #{@job_name}")

    google_user_identity = Repo.get(UserIdentity, id)
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    with {:ok, response} <- YouTube.Channel.mine(google_user_identity),
         inserted_youtube_channels <-
           Enum.map(response.body["items"], fn item ->
             Repo.insert(
               %YouTubeChannel{
                 body: item,
                 last_refreshed_at: now,
                 user_identity_id: google_user_identity.id,
                 youtube_id: item["id"]
               },
               on_conflict: {:replace_all_except, [:id, :youtube_id, :user_identity_id]},
               conflict_target: :youtube_id
             )
           end),
         changeset <-
           UserIdentity.changeset_last_refreshed_at(google_user_identity, %{
             last_refreshed_at: now
           }),
         {:ok, google_user_identity} <- Repo.update(changeset),
         {:ok, google_user_identity} <-
           UserIdentities.notify_subscribers(google_user_identity, [
             :updated,
             google_user_identity.provider
           ]),
         _queued_update_playlist_jobs <-
           Enum.each(inserted_youtube_channels, fn {:ok, youtube_channel} ->
             %{id: youtube_channel.id}
             |> Jobs.UpdateYouTubePlaylistItems.new()
             |> Oban.insert()
           end),
         do: {:ok, google_user_identity}

    Logger.info("[JOB] Completed #{@job_name}")

    :ok
  end
end
