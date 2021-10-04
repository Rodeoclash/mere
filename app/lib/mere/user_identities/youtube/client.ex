defmodule Mere.UserIdentities.YouTube.Client do
  alias Mere.{
    UserIdentities,
    YouTube
  }

  def new(user_identity) do
    case UserIdentities.refresh_token_expired?(user_identity) do
      true ->
        {:error, :refresh_token_expired}

      false ->
        if UserIdentities.access_token_expired?(user_identity) do
          with {:ok, user_identity} <- UserIdentities.refresh_access_token(user_identity),
               do: %YouTube.Client{
                 token: user_identity.access_token
               }
        else
          %YouTube.Client{
            token: user_identity.access_token
          }
        end
    end
  end
end
