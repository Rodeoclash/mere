defmodule Mere.YouTubeChannels.YouTubeChannel do
  alias Mere.{
    UserIdentities.UserIdentity
  }

  use Ecto.Schema

  schema "youtube_channels" do
    belongs_to :user_identity, UserIdentity

    field :body, :map
    field :last_refreshed_at, :utc_datetime
    field :youtube_id, :string

    timestamps()
  end

  def changeset(record_or_changeset, attrs) do
    record_or_changeset
    |> Ecto.Changeset.cast(attrs, [
      :body,
      :last_refreshed_at,
      :youtube_id
    ])
    |> Ecto.Changeset.validate_required([
      :body,
      :last_refreshed_at,
      :youtube_id
    ])
  end
end
