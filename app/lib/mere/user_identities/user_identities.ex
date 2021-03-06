defmodule Mere.UserIdentities do
  alias Mere.{
    Jobs,
    Repo,
    UserIdentities.Oauth2,
    UserIdentities.UserIdentity
  }

  require Logger

  @topic "user_identities"

  def refresh_access_token(user_identity) do
    client = Oauth2.Refresh.client(user_identity)

    with {:ok, client} <- OAuth2.Client.get_token(client),
         {:ok, access_token_expires_at} <- DateTime.from_unix(client.token.expires_at),
         changeset <-
           UserIdentity.changeset_refresh_access_token(user_identity, %{
             access_token: client.token.access_token,
             access_token_expires_at: access_token_expires_at
           }),
         {:ok, user_identity} <- Repo.update(changeset) do
      {:ok, user_identity}
    else
      {:error, reason} ->
        Logger.error("Unable to refresh token: #{inspect(reason)}")
        {:error, reason}
    end
  end

  def access_token_expired?(%{access_token_expires_at: access_token_expires_at}) do
    compared = DateTime.compare(DateTime.utc_now(), access_token_expires_at)
    compared == :gt || compared == :eq
  end

  def refresh_token_expired?(%{refresh_token_expires_at: refresh_token_expires_at}) do
    compared = DateTime.compare(DateTime.utc_now(), refresh_token_expires_at)
    compared == :gt || compared == :eq
  end

  def subscribe() do
    Phoenix.PubSub.subscribe(Mere.PubSub, @topic)
  end

  def notify_subscribers(user_identity, event) do
    Phoenix.PubSub.broadcast(
      Mere.PubSub,
      @topic,
      {__MODULE__, event, user_identity}
    )

    {:ok, user_identity}
  end

  def queue_refresh(user_identity) do
    %{id: user_identity.id}
    |> Jobs.UpdateYouTubeChannels.new()
    |> Oban.insert()
  end
end
