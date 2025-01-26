defmodule UniElixir.Repo.Migrations.SenderIdToUserId do
  use Ecto.Migration

  def change do
    rename table(:messages), :sender_id, to: :user_id
  end
end
