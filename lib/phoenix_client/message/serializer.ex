defmodule PhoenixClient.Message.Serializer do
  defmodule Error do
    defexception message: "Serialization error"
  end

  @callback decode!({:text | :binary, binary}, module) :: PhoenixClient.Message.t()
  @callback encode!(PhoenixClient.Message.t(), module) :: {:text | :binary, binary}
end
