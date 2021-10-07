defmodule Mere.Cron.RefreshUserIdentities do
  alias Mere.{
    Repo,
    UserIdentities,
    UserIdentities.UserIdentity
  }

  require Logger

  use Oban.Worker,
    queue: :cron,
    max_attempts: 1

  @job_name inspect(__MODULE__)

  @impl Oban.Worker
  def perform(_args) do
    log_message("Starting...") |> Logger.info()

    _updated_google_user_identities =
      UserIdentity.due_for_refresh_query()
      |> UserIdentity.where_provider_name_query("google")
      |> Repo.all()
      |> Enum.each(fn google_user_identity ->
        UserIdentities.queue_refresh(google_user_identity)
      end)

    log_message("Completed!") |> Logger.info()

    :ok
  end

  defp log_message(message) do
    "[CRON|#{@job_name}] #{message}"
  end
end
