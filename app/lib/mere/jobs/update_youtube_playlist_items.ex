defmodule Mere.Jobs.UpdateYouTubePlaylistItems do
  alias Mere.{
    Repo,
    YouTubeChannels,
    YouTubeChannels.YouTubeChannel,
    YouTubeChannels.YouTube,
    YouTubePlaylistItems.YouTubePlaylistItem
  }

  require Logger

  use Oban.Worker, queue: :update_youtube_playlist_item

  @job_name inspect(__MODULE__)

  def perform(%Oban.Job{args: %{"id" => id}}) do
    Logger.info("[JOB] Starting #{@job_name}")

    youtube_channel = Repo.get(YouTubeChannel, id)
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    with {:ok, response} <-
           YouTube.PlaylistItems.for_youtube_channel(youtube_channel),
         _playlist_items <-
           Enum.map(response.body["items"], fn item ->
             Repo.insert(
               %YouTubePlaylistItem{
                 body: item,
                 last_refreshed_at: now,
                 youtube_channel_id: youtube_channel.id,
                 youtube_id: item["id"]
               },
               on_conflict: {:replace_all_except, [:id, :youtube_id, :youtube_channel_id]},
               conflict_target: :youtube_id
             )
           end),
         changeset <-
           YouTubeChannel.changeset_last_refreshed_at(youtube_channel, %{
             last_refreshed_at: now
           }),
         {:ok, youtube_channel} <- Repo.update(changeset),
         {:ok, youtube_channel} <-
           YouTubeChannels.notify_subscribers(youtube_channel, [:updated]),
         do: {:ok, youtube_channel}

    Logger.info("[JOB] Completed #{@job_name}")

    :ok
  end
end
