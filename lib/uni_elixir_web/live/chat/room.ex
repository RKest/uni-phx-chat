defmodule UniElixirWeb.Chat.Room do
  use UniElixirWeb, :live_view

  import Ecto.Query
  
  alias UniElixir.Chat.{Room, Message}
  alias UniElixir.{Repo, Accounts}
  alias Phoenix.PubSub

  def pub_sub_topic(room_id) do
    "message_update_#{room_id}"
  end

  def get_room_messages(room_id) do
    from m in Message,
      where: m.room_id == ^room_id,
      preload: [:user]
  end

  def mount(%{"id" => id}, session, socket) do
    if connected?(socket), do: PubSub.subscribe(UniElixir.PubSub, pub_sub_topic(id))
    {:ok, 
    socket 
    |> assign(:messages, Repo.all(get_room_messages(id)))
    |> assign(:current_user, Accounts.get_user_by_session_token(session["user_token"]))
    |> assign(:current_room, Repo.get(Room, id))
    |> assign(:content, "")
    }
  end

  def handle_info({:new_messages_broad, messages}, socket) do
    {:noreply, assign(socket, :messages, messages)}
  end

  def handle_event("new_message", %{"content" => content}, socket) do
    res = %Message{content: content, user_id: socket.assigns.current_user.id, room_id: socket.assigns.current_room.id}
    |> Message.changeset(%{})
    |> Repo.insert()
    case res do
      {:ok, _name} -> 
        messages = Repo.all(get_room_messages(socket.assigns.current_room.id))
        PubSub.broadcast(
          UniElixir.PubSub, 
          pub_sub_topic(socket.assigns.current_room.id), 
          {:new_messages_broad, messages})

        {:noreply,
          socket
          |> put_flash(:info, "Written a message")
          |> assign(:messages, messages)
          |> assign(:content, "")
        }
      {:error, _changeset} -> {:noreply, socket |> put_flash(:error, "Failed to create room")}
    end
  end

  def render(assigns) do
    ~H"""
      <ul>
        <li :for={message <- @messages}>
          <p><strong>{ message.user.email }</strong></p>
          <p>{ message.content }</p>
          <hr>
        </li>
      </ul>
      <.form for={%{}} phx-submit="new_message">
        <.input type="text" name="content" value={@content} label="Enter message" required />
        <.button type="submit">Submit message</.button>
      </.form>
    """
  end
end
