defmodule Mere.YouTubeChannels.YouTubeChannel do
  alias __MODULE__

  alias Mere.{
    UserIdentities.UserIdentity,
    Users.User,
    YouTubePlaylistItems.YouTubePlaylistItem
  }

  import Ecto.Query

  use Ecto.Schema

  schema "youtube_channels" do
    belongs_to :user_identity, UserIdentity
    has_one :user, through: [:user_identity, :user]

    field :body, :map
    field :last_refreshed_at, :utc_datetime
    field :youtube_id, :string

    has_many :youtube_playlist_items, YouTubePlaylistItem, foreign_key: :youtube_channel_id

    timestamps()
  end

  def changeset(record_or_changeset, attrs) do
    record_or_changeset
    |> Ecto.Changeset.cast(attrs, [
      :body,
      :last_refreshed_at,
      :youtube_id
    ])
    |> Ecto.Changeset.validate_required([
      :body,
      :last_refreshed_at,
      :youtube_id
    ])
  end

  def changeset_last_refreshed_at(record_or_changeset, attrs) do
    record_or_changeset
    |> Ecto.Changeset.cast(attrs, [
      :last_refreshed_at
    ])
    |> Ecto.Changeset.validate_required([
      :last_refreshed_at
    ])
  end

  def where_user_id_query(query \\ YouTubeChannel, id) do
    query
    |> join(:inner, [youtube_channel], user_identity in UserIdentity,
      on: user_identity.id == youtube_channel.user_identity_id
    )
    |> join(:inner, [youtube_channel, user_identity], user in User,
      on: user.id == user_identity.user_id
    )
    |> where([youtube_channel, user_identity, user], user.id == ^id)
    |> limit(1)
  end

  def where_ids_query(query \\ YouTubeChannel, ids) do
    query
    |> where([youtube_channel], youtube_channel.id in ^ids)
  end

  def latest_inserted_query(query \\ YouTubeChannel) do
    query
    |> order_by([youtube_channel], desc: youtube_channel.inserted_at)
  end

  def preload_settings_query(query \\ YouTubeChannel) do
    query
    |> latest_inserted_query()
  end
end
