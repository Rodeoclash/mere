defmodule Mere.YouTubeChannels.YouTubeChannel do
  alias Mere.{
    UserIdentities.UserIdentity
  }

  use Ecto.Schema

  schema "youtube_channels" do
    belongs_to :user_identity, UserIdentity

    field :body, :map
    field :mine, :boolean
    field :last_refreshed_at, :utc_datetime

    timestamps()
  end
end
