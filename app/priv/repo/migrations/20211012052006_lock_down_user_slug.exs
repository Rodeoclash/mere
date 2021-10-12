defmodule Mere.Repo.Migrations.LockDownUserSlug do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify(:slug, :string, null: false, from: :string)
    end

    create unique_index(:users, :slug)
  end
end
