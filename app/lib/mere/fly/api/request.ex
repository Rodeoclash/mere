defmodule Mere.Fly.Api.Request do
  alias __MODULE__
  @enforce_keys [:query, :variables]
  defstruct [:query, :variables]

  def new(data) do
    %Request{
      query: data[:query],
      variables: data[:variables]
    }
  end
end
