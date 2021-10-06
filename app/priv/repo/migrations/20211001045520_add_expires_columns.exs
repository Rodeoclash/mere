defmodule Mere.Repo.Migrations.AddExpiresColumns do
  use Ecto.Migration

  def change do
    alter table(:user_identities) do
      add :access_token_expires_at, :utc_datetime, null: false
      add :refresh_token_expires_at, :utc_datetime, null: false
    end
  end
end
