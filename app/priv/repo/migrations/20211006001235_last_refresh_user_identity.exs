defmodule Mere.Repo.Migrations.LastRefreshUserIdentity do
  use Ecto.Migration

  def change do
    alter table(:user_identities) do
      add :last_refreshed_at, :utc_datetime
    end
  end
end
