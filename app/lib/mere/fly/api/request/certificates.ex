defmodule Mere.Fly.Api.Request.Certificates do
  alias Mere.Fly.{
    Api
  }

  def get do
    query = """
      query getCertificates($appName: String!) {
        app(name: $appName) {
          certificates {
            nodes {
              clientStatus
              createdAt
              hostname
            }
          }
        }
      }
    """

    Api.Request.new(%{
      query: query,
      variables: Api.default_variables()
    })
  end
end
