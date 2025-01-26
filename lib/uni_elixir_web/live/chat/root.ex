defmodule UniElixirWeb.Chat.Root do
  use UniElixirWeb, :live_view

  alias UniElixir.Chat.Room
  alias UniElixir.Repo
  alias Phoenix.PubSub

  @topic "names_update"

  def mount(_params, _session, socket) do
    if connected?(socket), do: PubSub.subscribe(UniElixir.PubSub, @topic)
    {:ok,
    socket
    |> assign(:rooms, Repo.all(Room))
    |> assign(:title, "")
    }
  end

  def handle_info({:new_room_broad, rooms}, socket) do
    {:noreply, assign(socket, :rooms, rooms)}
  end

  def handle_event("new_room", %{"title" => title}, socket) do
    res = %Room{title: title}
    |> Room.changeset(%{})
    |> Repo.insert()
    case res do
      {:ok, _name} -> 
        rooms = Repo.all(Room)
        PubSub.broadcast(UniElixir.PubSub, @topic, {:new_room_broad, rooms})

        {:noreply,
          socket
          |> put_flash(:info, "Created a room")
          |> assign(:rooms, rooms)
          |> assign(:title, "")
        }
      {:error, _changeset} -> {:noreply, socket |> put_flash(:error, "Failed to create room")}
    end
  end

  def render(assigns) do
    ~H"""
      <ul>
        <li :for={room <- @rooms}>
          <a href={~p"/room/#{room.id}"}>{room.title}</a>
        </li>
      </ul>
      <.form for={%{}} phx-submit="new_room">
        <.input type="text" name="title" value={@title} label="New room title" required />
        <.button type="submit">Create Room</.button>
      </.form>
    """
  end
end
