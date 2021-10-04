defmodule Mere.YouTube do
  use HTTPoison.Base

  def process_request_url(url) do
    "https://www.googleapis.com/youtube/v3" <> url
  end

  def process_response_body(body) do
    body
    |> Jason.decode!()
  end

  def default_headers(%{token: token}) do
    [
      Accept: "Application/json; Charset=utf-8",
      Authorization: "Bearer #{token}"
    ]
  end

  def _get(client, path, params) do
    path = "#{path}?&#{URI.encode_query(params)}"

    get(
      path,
      default_headers(client)
    )
  end
end
