defmodule MereWeb.SettingsLive.Index do
  use MereWeb, :live_view

  alias Mere.YouTubeChannels
  alias Mere.YouTubeChannels.YouTubeChannel

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :data, data())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Youtube channels")
    |> assign(:you_tube_channel, nil)
  end

  defp data do
    # YouTubeChannels.list_youtube_channels()
    %{
      youtube_channel: %{}
    }
    |> Jason.encode!()
  end
end
