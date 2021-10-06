defmodule Mere.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema
  use PowAssent.Ecto.Schema

  schema "users" do
    pow_user_fields()

    has_many :youtube_channels, through: [:user_identities, :youtube_channels]
    has_many :youtube_playlist_items, through: [:youtube_channels, :youtube_channels]

    timestamps()
  end
end
