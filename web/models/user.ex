defmodule Dbs.User do
  use Dbs.Web, :model

  schema "users" do
    field :name, :string
    has_many :rooms, Dbs.Room

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
