defmodule PhoenixClient.Message.Serializer do
  @callback decode!({:text | :binary, binary}, module) :: PhoenixClient.Message.t()
  @callback encode!(PhoenixClient.Message.t(), module) :: {:text | :binary, binary}
end
