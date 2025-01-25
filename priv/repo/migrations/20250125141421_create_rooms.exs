defmodule UniElixir.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :title, :string

      timestamps(type: :utc_datetime)
    end
  end
end
