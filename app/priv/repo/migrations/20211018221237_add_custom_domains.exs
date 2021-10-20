defmodule Mere.Repo.Migrations.AddCustomDomains do
  use Ecto.Migration

  def change do
    create table(:custom_domains) do
      add :hostname, :string, null: false
      add :user_id, references("users", on_delete: :delete_all)
      add :successfully_pinged_at, :utc_datetime
      add :last_pinged_at, :utc_datetime
      add :status, :string, default: "Unchecked", null: false

      timestamps()
    end

    create unique_index(:custom_domains, :hostname)
  end
end
