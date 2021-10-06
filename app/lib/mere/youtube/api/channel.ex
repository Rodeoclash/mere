defmodule Mere.YouTube.Api.Channel do
  alias Mere.{
    YouTube
  }

  @default_params %{
    part: "snippet,contentDetails,brandingSettings"
  }

  @path "channels"

  def list(client, params \\ %{}) do
    params = Map.merge(@default_params, params)

    YouTube._get(
      client,
      "/#{@path}",
      params
    )
  end
end
