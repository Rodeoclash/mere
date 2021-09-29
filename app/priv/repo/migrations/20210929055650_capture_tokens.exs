defmodule Mere.Repo.Migrations.CaptureTokens do
  use Ecto.Migration

  def change do
    alter table(:user_identities) do
      add :access_token, :string, null: false
      add :refresh_token, :string, null: false
    end
  end
end
