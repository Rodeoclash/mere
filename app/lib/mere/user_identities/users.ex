defmodule Mere.UserIdentities.Users do
  alias Mere.{
    Repo,
    UserIdentities.UserIdentity
  }

  def google_identity(user) do
    Repo.get_by(UserIdentity, %{
      provider: "google",
      user_id: user.id
    })
  end
end
