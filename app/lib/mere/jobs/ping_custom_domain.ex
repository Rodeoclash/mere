defmodule Mere.Jobs.PingCustomDomain do
  alias Mere.{
    CustomDomains.CustomDomain,
    Repo
  }

  require Logger

  use Oban.Worker,
    queue: :ping_custom_domain

  @job_name inspect(__MODULE__)

  def perform(%Oban.Job{attempt: attempt, args: %{"hostname" => hostname}} = job) do
    log_message("Starting...") |> Logger.info()

    now = DateTime.utc_now() |> DateTime.truncate(:second)

    case Repo.get_by(CustomDomain, %{hostname: hostname}) do
      nil ->
        log_message("Completed by db record being removed") |> Logger.info()
        :ok

      custom_domain ->
        case HTTPoison.get(hostname) do
          {:ok, _response} ->
            CustomDomain.changeset(custom_domain, %{
              successfully_pinged_at: now,
              last_pinged_at: now,
              status: "Working"
            })
            |> Repo.update()

            log_message("Completed by finding hostname") |> Logger.info()

            :ok

          {:error, error} ->
            CustomDomain.changeset(custom_domain, %{
              last_pinged_at: now,
              status: error.reason
            })
            |> Repo.update()

            log_message("Found HTTP error, snoozing before retry, attempt: #{attempt}")
            |> Logger.info()

            {:error, "HTTP error"}
        end
    end
  end

  defp log_message(message) do
    "[JOB|#{@job_name}] #{message}"
  end
end
