defmodule Mere.Repo.Migrations.AddYouTubePlaylistItem do
  use Ecto.Migration

  def change do
    create table(:youtube_playlist_items) do
      add :body, :map, null: false
      add :last_refreshed_at, :utc_datetime, null: false
      add :youtube_channel_id, references("youtube_channels", on_delete: :delete_all)
      add :youtube_id, :string, null: false

      timestamps()
    end

    create unique_index(:youtube_playlist_items, :youtube_id)
  end
end
