defmodule Mere.Fly.Api do
  use HTTPoison.Base

  def perform(request) do
    post(endpoint(), %{
      query: request.query,
      variables: request.variables
    })
  end

  def default_variables() do
    %{
      "appName" => app_name()
    }
  end

  def process_request_headers(headers) do
    headers ++
      [
        "Content-Type": "application/json",
        Authorization: "Bearer #{token()}"
      ]
  end

  def process_request_body(body) do
    Jason.encode!(body)
  end

  def process_response_body(body) do
    body
    |> Jason.decode!()
  end

  defp app_name do
    Application.get_env(:mere, :fly)[:app_name]
  end

  defp token do
    Application.get_env(:mere, :fly)[:access_token]
  end

  defp endpoint do
    "https://api.fly.io/graphql"
  end
end
