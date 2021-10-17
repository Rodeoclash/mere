defmodule Mere.Repo.Migrations.ImageAttribution do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :theme_background_creator, :string
      add :theme_background_creator_url, :string
    end
  end
end
