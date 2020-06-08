defmodule PhoenixClient.Message.V2 do
  alias PhoenixClient.Message
  @behaviour Message.Serializer

  def decode!({:text, msg}, json_library) do
    [join_ref, ref, topic, event, payload | _] = json_library.decode!(msg)

    %Message{
      join_ref: join_ref,
      ref: ref,
      topic: topic,
      event: event,
      payload: payload
    }
  end

  def decode!(msg, _) do
    raise Message.Serializer.Error, message: "Unsupported message: #{inspect(msg)}"
  end

  def encode!(%Message{} = msg, json_library) do
    {:text,
     [msg.join_ref, msg.ref, msg.topic, msg.event, msg.payload]
     |> json_library.encode!()}
  end
end
