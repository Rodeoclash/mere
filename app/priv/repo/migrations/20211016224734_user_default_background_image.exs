defmodule Mere.Repo.Migrations.UserDefaultBackgroundImage do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :theme_background, :string
    end
  end
end
