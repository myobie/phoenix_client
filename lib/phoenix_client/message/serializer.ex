defmodule PhoenixClient.Message.Serializer do
  @callback decode!(binary, module) :: PhoenixClient.Message.t()
  @callback encode!(PhoenixClient.Message.t(), module) :: binary
end
