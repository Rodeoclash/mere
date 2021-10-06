defmodule Mere.Cron.RefreshUserIdentities do
  alias Mere.{
    Repo,
    UserIdentities,
    UserIdentities.UserIdentity
  }

  require Logger

  use Oban.Worker, queue: :cron

  @job_name inspect(__MODULE__)

  @impl Oban.Worker
  def perform(_args) do
    Logger.info("[JOB] Starting #{@job_name}")

    _updated_google_user_identities =
      UserIdentity.due_for_refresh_query()
      |> UserIdentity.where_provider_name_query("google")
      |> Repo.all()
      |> Enum.each(fn google_user_identity ->
        UserIdentities.queue_refresh(google_user_identity)
      end)

    Logger.info("[JOB] Completed #{@job_name}")

    :ok
  end
end
