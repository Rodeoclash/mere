defmodule Mere.YouTubePlaylistItems.YouTubePlaylistItem do
  alias Mere.{
    YouTubeChannels.YouTubeChannel
  }

  use Ecto.Schema

  schema "youtube_playlist_items" do
    belongs_to :youtube_channel, YouTubeChannel

    field :body, :map
    field :last_refreshed_at, :utc_datetime
    field :youtube_id, :string

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
end
