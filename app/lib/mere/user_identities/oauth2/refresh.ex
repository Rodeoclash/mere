defmodule Mere.UserIdentities.Oauth2.Refresh do
  def client(%{refresh_token: refresh_token}) do
    OAuth2.Client.new(
      client_id: Application.get_env(:mere, :oauth2)[:providers][:google][:client_id],
      client_secret: Application.get_env(:mere, :oauth2)[:providers][:google][:client_secret],
      params: %{"refresh_token" => refresh_token},
      site: "https://oauth2.googleapis.com",
      strategy: OAuth2.Strategy.Refresh,
      token_url: "/token"
    )
    |> OAuth2.Client.put_serializer("application/json", Jason)
  end
end
