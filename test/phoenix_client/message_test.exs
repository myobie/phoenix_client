defmodule PhoenixClient.MessageTest do
  use ExUnit.Case, async: false

  alias PhoenixClient.Message

  describe "v1 serializer" do
    test "encode" do
      msg = %{
        ref: "1",
        topic: "1234",
        event: "new:thing",
        payload: %{"a" => "b"}
      }

      frame = {:text, Jason.encode!(msg)}
      v1_msg = Message.V1.encode!(struct(Message, msg), Jason)

      assert frame == v1_msg
    end

    test "decode" do
      msg = %{
        "ref" => "1",
        "topic" => "1234",
        "event" => "new:thing",
        "payload" => %{"a" => "b"}
      }

      frame = {:text, Jason.encode!(msg)}
      v1_msg = Message.V1.decode!(frame, Jason)

      assert to_struct(Message, msg) == v1_msg
    end

    test "does not support binary frames" do
      assert_raise Message.Serializer.Error, fn ->
        Message.V1.decode!({:binary, <<42>>}, Jason)
      end
    end
  end

  describe "v2 serializer" do
    test "encode" do
      msg = %{
        join_ref: "1",
        ref: "1",
        topic: "1234",
        event: "new:thing",
        payload: %{"a" => "b"}
      }

      frame = {:text, Jason.encode!(["1", "1", "1234", "new:thing", %{"a" => "b"}])}
      v2_msg = Message.V2.encode!(struct(Message, msg), Jason)

      assert frame == v2_msg
    end

    test "decode" do
      msg = %{
        join_ref: "1",
        ref: "1",
        topic: "1234",
        event: "new:thing",
        payload: %{"a" => "b"}
      }

      frame = {:text, Jason.encode!(["1", "1", "1234", "new:thing", %{"a" => "b"}])}
      v2_msg = Message.V2.decode!(frame, Jason)

      assert struct(Message, msg) == v2_msg
    end

    test "does not support binary frames" do
      assert_raise Message.Serializer.Error, fn ->
        Message.V2.decode!({:binary, <<42>>}, Jason)
      end
    end
  end

  def to_struct(kind, attrs) do
    struct = struct(kind)

    Enum.reduce(Map.to_list(struct), struct, fn {k, _}, acc ->
      case Map.fetch(attrs, Atom.to_string(k)) do
        {:ok, v} -> %{acc | k => v}
        :error -> acc
      end
    end)
  end
end
