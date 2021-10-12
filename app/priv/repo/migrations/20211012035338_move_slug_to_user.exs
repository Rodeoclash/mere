defmodule Mere.Repo.Migrations.MoveSlugToUser do
  use Ecto.Migration

  def up do
    execute """
    ALTER TABLE youtube_channels DROP COLUMN slug;
    """

    alter table(:users) do
      add :slug, :string
    end
  end

  def down do
    alter table(:users) do
      remove :slug, :string
    end

    execute """
    ALTER TABLE youtube_channels ADD COLUMN slug TEXT generated always AS (
      LOWER(regexp_replace(body->'snippet'->>'title', '[^a-zA-Z0-9]', '', 'g'))
    ) stored NOT NULL;
    """

    create unique_index(:youtube_channels, :slug)
  end
end
