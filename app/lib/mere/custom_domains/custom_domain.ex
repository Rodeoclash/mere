defmodule Mere.CustomDomains.CustomDomain do
  alias __MODULE__

  alias Mere.{
    Users.User
  }

  import Ecto.Query

  use Ecto.Schema

  schema "custom_domains" do
    belongs_to :user, User

    field :resource, :string

    timestamps()
  end

  def changeset(record_or_changeset, attrs \\ %{}) do
    record_or_changeset
    |> Ecto.Changeset.cast(attrs, [
      :resource,
      :user_id
    ])
    |> Ecto.Changeset.unique_constraint(:resource)
    |> Ecto.Changeset.validate_required([
      :resource,
      :user_id
    ])
  end

  def where_user_id_query(query \\ CustomDomain, id) do
    query
    |> where([custom_domain], custom_domain.user_id == ^id)
  end
end
