defmodule Mere.YouTubePlaylistItems.YouTubePlaylistItem do
  alias __MODULE__

  alias Mere.{
    YouTubeChannels.YouTubeChannel
  }

  import Ecto.Query

  use Ecto.Schema

  schema "youtube_playlist_items" do
    belongs_to :youtube_channel, YouTubeChannel

    field :body, :map
    field :last_refreshed_at, :utc_datetime
    field :youtube_id, :string

    field :title, :string, virtual: true
    field :description, :string, virtual: true

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

  def public_videos_query(query \\ YouTubePlaylistItem) do
    query
    |> where([youtube_playlist_item], fragment("body->'status'->>'privacyStatus'") == "public")
  end

  # TODO: Should be based on position
  def latest_inserted_query(query \\ YouTubePlaylistItem) do
    query
    |> order_by([youtube_playlist_item], desc: youtube_playlist_item.inserted_at)
  end

  def preload_settings_query(query \\ YouTubePlaylistItem) do
    query
    |> public_videos_query()
    |> latest_inserted_query()
  end
end
