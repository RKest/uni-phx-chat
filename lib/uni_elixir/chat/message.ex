defmodule UniElixir.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset

  alias UniElixir.Chat.Room
  alias UniElixir.Accounts.User

  schema "messages" do
    field :content, :string
    belongs_to :room, Room 
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
