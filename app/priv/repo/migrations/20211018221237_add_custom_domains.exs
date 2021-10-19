defmodule Mere.Repo.Migrations.AddCustomDomains do
  use Ecto.Migration

  def change do
    create table(:custom_domains) do
      add :resource, :string, null: false
      add :user_id, references("users", on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:custom_domains, :resource)
  end
end
