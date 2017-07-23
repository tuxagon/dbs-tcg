defmodule Dbs.Room do
  use Dbs.Web, :model

  schema "rooms" do
    field :name, :string
    belongs_to :player1, Dbs.User
    belongs_to :player2, Dbs.User

    timestamps(type: :utc_datetime)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
