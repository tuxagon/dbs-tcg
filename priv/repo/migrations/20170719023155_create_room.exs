defmodule Dbs.Repo.Migrations.CreateRoom do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string
      add :player1_id, references(:users, on_delete: :nothing)
      add :player2_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:rooms, [:player1_id])
    create index(:rooms, [:player2_id])

  end
end
