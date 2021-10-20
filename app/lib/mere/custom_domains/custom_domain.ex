defmodule Mere.CustomDomains.CustomDomain do
  alias __MODULE__

  alias Mere.{
    Users.User
  }

  import Ecto.Query

  use Ecto.Schema

  schema "custom_domains" do
    belongs_to :user, User

    field :hostname, :string
    field :status, :string
    field :successfully_pinged_at, :utc_datetime
    field :last_pinged_at, :utc_datetime

    timestamps()
  end

  def changeset(record_or_changeset, attrs \\ %{}) do
    record_or_changeset
    |> Ecto.Changeset.cast(attrs, [
      :hostname,
      :user_id,
      :status,
      :successfully_pinged_at,
      :last_pinged_at
    ])
    |> Ecto.Changeset.unique_constraint(:hostname)
    |> Ecto.Changeset.validate_required([
      :hostname,
      :user_id
    ])
  end

  def where_user_id_query(query \\ CustomDomain, id) do
    query
    |> where([custom_domain], custom_domain.user_id == ^id)
  end
end
