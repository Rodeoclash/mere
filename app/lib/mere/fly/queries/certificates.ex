defmodule Mere.Fly.Queries.Certificates do
  alias Mere.Fly.{
    Api
  }

  def get do
    Api.Request.Certificates.get()
    |> Api.perform()
  end

  def create(hostname) do
    Api.Request.Certificates.create(hostname)
    |> Api.perform()
  end

  def delete(hostname) do
    Api.Request.Certificates.delete(hostname)
    |> Api.perform()
  end
end
