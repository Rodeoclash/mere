defmodule MereWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  def time_from_now(time) do
    Mere.Cldr.DateTime.Relative.to_string!(time, relative_to: DateTime.utc_now())
  end

  def youtube_channel_to_url(youtube_channel) do
    url =
      MereWeb.Endpoint.url()
      |> URI.parse()

    %{url | host: "#{youtube_channel.slug}.#{url.host}"}
    |> URI.to_string()
  end
end
