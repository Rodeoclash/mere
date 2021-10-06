defmodule MereWeb.SettingsLive.Youtube do
  alias Mere.{
    Repo,
    UserIdentities,
    UserIdentities.UserIdentity,
    YouTubeChannels,
    YouTubeChannels.YouTubeChannel
  }

  alias MereWeb.{
    Components
  }

  use MereWeb, :live_view

  @provider "google"

  @impl true
  def mount(_params, session, socket) do
    google_user_identity =
      Repo.get_by(UserIdentity, %{user_id: session["current_user_id"], provider: @provider})

    if connected?(socket) == true do
      UserIdentities.subscribe()
      YouTubeChannels.subscribe()
    end

    {:ok, fetch(socket, google_user_identity)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_info({UserIdentities, [:updated, @provider], google_user_identity}, socket) do
    if socket.assigns[:google_user_identity].id == google_user_identity.id do
      {:noreply, fetch(socket, google_user_identity)}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_info({YouTubeChannels, [:updated], youtube_channel}, socket) do
    send_update(Components.YouTubeChannelSettings,
      id: youtube_channel.id,
      youtube_channel_id: youtube_channel.id
    )

    {:noreply, socket}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "YouTube settings")
  end

  defp fetch(socket, google_user_identity) do
    socket
    |> assign(:google_user_identity, data(google_user_identity))
  end

  defp data(google_user_identity) do
    UserIdentity
    |> UserIdentity.where_id_query(google_user_identity.id)
    |> UserIdentity.where_provider_name_query(google_user_identity.provider)
    |> Repo.one()
    |> Repo.preload(youtube_channels: YouTubeChannel.preload_settings_query())
  end
end
