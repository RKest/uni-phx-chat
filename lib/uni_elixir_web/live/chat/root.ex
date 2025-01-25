defmodule UniElixirWeb.Chat.Root do
  use UniElixirWeb, :live_view

  alias UniElixirWeb.Chat.{Rooms}

  def mount(_params, _session, socket) do
    {:ok,
    socket
    |> assign(:rooms, [])
    }
  end

  def handle_params(%{}, _uri, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <Rooms.list rooms={[%{name: "Foo"}, %{name: "Bar"}]} />
    """
  end
end
