defmodule Mere.UserIdentities.YouTube.Channel do
  alias Mere.{
    UserIdentities,
    YouTube
  }

  def mine(user_identity) do
    UserIdentities.YouTube.Client.new(user_identity)
    |> YouTube.Api.Channel.list(%{
      "mine" => "true"
    })
  end

  def for_username(user_identity, username) do
    UserIdentities.YouTube.Client.new(user_identity)
    |> YouTube.Api.Channel.list(%{
      "forUsername" => username
    })
  end
end
