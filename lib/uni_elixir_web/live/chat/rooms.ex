defmodule UniElixirWeb.Chat.Rooms do
  use Phoenix.Component
  use UniElixirWeb, :html

  def list(assigns) do
    ~H"""
      <ul>
        <li :for={room <- @rooms}>
          <div>Hello {room.name}</div>
        </li>
      </ul>
    """
  end
end
