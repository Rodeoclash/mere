defmodule Mere.UserIdentities.UserIdentity do
  alias __MODULE__

  alias Mere.{
    YouTubeChannels.YouTubeChannel
  }

  import Ecto.Query

  use Ecto.Schema
  use PowAssent.Ecto.UserIdentities.Schema, user: Mere.Users.User

  # how many seconds between refreshes?
  @refresh_after 3600

  schema "user_identities" do
    field :access_token, :string
    field :access_token_expires_at, :utc_datetime
    field :refresh_token, :string
    field :refresh_token_expires_at, :utc_datetime

    field :last_refreshed_at, :utc_datetime

    has_many :youtube_channels, YouTubeChannel

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

  def changeset_last_refreshed_at(record_or_changeset, attrs) do
    record_or_changeset
    |> Ecto.Changeset.cast(attrs, [
      :last_refreshed_at
    ])
    |> Ecto.Changeset.validate_required([
      :last_refreshed_at
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

  def where_id_query(query \\ UserIdentity, id) do
    query
    |> where([user_identity], user_identity.id == ^id)
  end

  def where_provider_name_query(query \\ UserIdentity, name) do
    query
    |> where([user_identity], user_identity.provider == ^name)
  end

  def due_for_refresh_query(query \\ UserIdentity) do
    from =
      DateTime.utc_now()
      |> DateTime.add(@refresh_after * -1, :second)
      |> DateTime.truncate(:second)

    query
    |> where(
      [user_identity],
      user_identity.last_refreshed_at <= ^from or is_nil(user_identity.last_refreshed_at)
    )
  end
end
