defmodule MereWeb.SharedView do
  use MereWeb, :view

  def user_url(user) do
    url =
      MereWeb.Endpoint.url()
      |> URI.parse()

    %{url | host: "#{user.slug}.#{url.host}"}
    |> URI.to_string()
  end
end
