defmodule PhoenixClient.Message.V1 do
  alias PhoenixClient.Message
  @behaviour Message.Serializer

  def decode!({:text, msg}, json_library) do
    map = json_library.decode!(msg)

    %Message{
      ref: map["ref"],
      topic: map["topic"],
      event: map["event"],
      payload: map["payload"]
    }
  end

  def encode!(%Message{} = msg, json_library) do
    {:text,
     msg
     |> Map.take([:topic, :event, :payload, :ref])
     |> json_library.encode!()}
  end
end
