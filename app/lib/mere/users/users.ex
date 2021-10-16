defmodule Mere.Users do
  def format_slug(slug) do
    slug
    |> String.downcase()
    |> String.replace(~r/[[:punct:]]/, "")
  end
end
