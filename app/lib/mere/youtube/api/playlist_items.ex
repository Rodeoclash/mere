defmodule Mere.YouTube.Api.PlaylistItems do
  alias Mere.{
    YouTube
  }

  @default_params %{
    part: "snippet,contentDetails,status"
  }

  @path "playlistItems"

  def list(client, params \\ %{}) do
    params = Map.merge(@default_params, params)

    YouTube._get(
      client,
      "/#{@path}",
      params
    )
  end
end
