defmodule Mere.Fly.Queries.Certificates do
  alias Mere.Fly.{
    Api
  }

  def get do
    Api.Request.Certificates.get()
    |> Api.perform()
  end
end
