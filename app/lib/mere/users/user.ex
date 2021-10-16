defmodule Mere.Users.User do
  alias Mere.{
    Users
  }

  use Ecto.Schema
  use Pow.Ecto.Schema
  use PowAssent.Ecto.Schema

  schema "users" do
    pow_user_fields()

    has_many :youtube_channels, through: [:user_identities, :youtube_channels]
    has_many :youtube_playlist_items, through: [:youtube_channels, :youtube_channels]

    field :slug, :string

    timestamps()
  end

  def user_identity_changeset(user_or_changeset, user_identity, attrs, user_id_attrs) do
    user_or_changeset
    |> pow_assent_user_identity_changeset(user_identity, attrs, user_id_attrs)
    |> generate_slug
    |> Ecto.Changeset.cast(attrs, [:slug])
    |> Ecto.Changeset.validate_required([:slug])
  end

  def changeset(record_or_changeset, attrs \\ %{}) do
    record_or_changeset
    |> Ecto.Changeset.cast(attrs, [:slug])
    |> format_slug
    |> Ecto.Changeset.validate_required([:slug])
  end

  defp generate_slug(changeset) do
    changeset
    |> Ecto.Changeset.put_change(:slug, Users.Name.generate())
  end

  defp format_slug(changeset) do
    formatted_slug =
      changeset
      |> Ecto.Changeset.get_field(:slug)
      |> Users.format_slug()

    changeset
    |> Ecto.Changeset.put_change(:slug, formatted_slug)
  end
end
