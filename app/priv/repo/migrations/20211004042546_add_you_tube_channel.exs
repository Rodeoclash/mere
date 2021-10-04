defmodule Mere.Repo.Migrations.AddYouTubeChannel do
  use Ecto.Migration

  def change do
    create table(:youtube_channels) do
      add :body, :map, null: false
      add :last_refreshed_at, :utc_datetime, null: false
      add :mine, :boolean, null: false
      add :user_identity_id, references("user_identities", on_delete: :nothing)

      timestamps()
    end
  end
end
