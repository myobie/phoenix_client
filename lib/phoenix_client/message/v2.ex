defmodule PhoenixClient.Message.V2 do
  alias PhoenixClient.Message
  @behaviour Message.Serializer

  def decode!(msg, json_library) do
    [join_ref, ref, topic, event, payload | _] = json_library.decode!(msg)

    %Message{
      join_ref: join_ref,
      ref: ref,
      topic: topic,
      event: event,
      payload: payload
    }
  end

  def encode!(%Message{} = msg, json_library) do
    [msg.join_ref, msg.ref, msg.topic, msg.event, msg.payload]
    |> json_library.encode!()
  end
end
