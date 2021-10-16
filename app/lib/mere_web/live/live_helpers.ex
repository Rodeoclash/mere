defmodule MereWeb.LiveHelpers do
  alias Mere.{
    Repo
  }

  import Phoenix.LiveView.Helpers

  def time_from_now(time) do
    Mere.Cldr.DateTime.Relative.to_string!(time, relative_to: DateTime.utc_now())
  end

  def youtube_channel_to_user_url(youtube_channel) do
    youtube_channel = Repo.preload(youtube_channel, :user)
    MereWeb.SharedView.user_url(youtube_channel.user)
  end
end
