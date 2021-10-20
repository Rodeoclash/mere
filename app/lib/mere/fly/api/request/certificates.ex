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

  def create(hostname) do
    query = """
      mutation($appId: ID!, $hostname: String!) {
          addCertificate(appId: $appId, hostname: $hostname) {
              certificate {
                  configured
                  acmeDnsConfigured
                  acmeAlpnConfigured
                  certificateAuthority
                  certificateRequestedAt
                  dnsProvider
                  dnsValidationInstructions
                  dnsValidationHostname
                  dnsValidationTarget
                  hostname
                  id
                  source
              }
          }
      }
    """

    Api.Request.new(%{
      query: query,
      variables: Map.merge(Api.default_variables(), %{hostname: hostname})
    })
  end

  def delete(hostname) do
    query = """
     mutation($appId: ID!, $hostname: String!) {
          deleteCertificate(appId: $appId, hostname: $hostname) {
              app {
                  name
              }
              certificate {
                  hostname
                  id
              }
          }
      }
    """

    Api.Request.new(%{
      query: query,
      variables: Map.merge(Api.default_variables(), %{hostname: hostname})
    })
  end
end
