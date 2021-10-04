defmodule Mere.UserIdentities.UserIdentity do
  alias Mere.{
    YouTubeChannels
  }

  use Ecto.Schema
  use PowAssent.Ecto.UserIdentities.Schema, user: Mere.Users.User

  schema "user_identities" do
    field :access_token, :string
    field :access_token_expires_at, :utc_datetime
    field :refresh_token, :string
    field :refresh_token_expires_at, :utc_datetime

    has_many :youtube_channels, YouTubeChannels.YouTubeChannel

    pow_assent_user_identity_fields()

    timestamps()
  end

  def changeset(record_or_changeset, attrs) do
    token_params = Map.get(attrs, "token", attrs)

    record_or_changeset
    |> pow_assent_changeset(attrs)
    |> set_expires
    |> Ecto.Changeset.cast(token_params, [
      :access_token,
      :access_token_expires_at,
      :refresh_token,
      :refresh_token_expires_at
    ])
    |> Ecto.Changeset.validate_required([
      :access_token,
      :access_token_expires_at,
      :refresh_token,
      :refresh_token_expires_at
    ])
  end

  def changeset_refresh_access_token(record_or_changeset, attrs) do
    record_or_changeset
    |> Ecto.Changeset.cast(attrs, [
      :access_token,
      :access_token_expires_at
    ])
    |> Ecto.Changeset.validate_required([
      :access_token,
      :access_token_expires_at
    ])
  end

  def set_expires(changeset) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    # 25 minutes
    access_token_expires_at = DateTime.add(now, 1500, :second)

    # 150 days
    refresh_token_expires_at = DateTime.add(now, 12_960_000, :second)

    changeset
    |> Ecto.Changeset.put_change(:access_token_expires_at, access_token_expires_at)
    |> Ecto.Changeset.put_change(:refresh_token_expires_at, refresh_token_expires_at)
  end
end
