defmodule Mere.YouTubeChannels.YouTubeChannel do
  alias __MODULE__

  alias Mere.{
    UserIdentities.UserIdentity,
    YouTubePlaylistItems.YouTubePlaylistItem
  }

  import Ecto.Query

  use Ecto.Schema

  schema "youtube_channels" do
    belongs_to :user_identity, UserIdentity

    field :body, :map
    field :last_refreshed_at, :utc_datetime
    field :slug, :string, read_after_writes: true
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
