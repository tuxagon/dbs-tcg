defmodule Dbs.RoomChannel do
  use Dbs.Web, :channel

  def join("room:lobby", _params, socket) do
    rooms = Dbs.Room |> Repo.all |> Repo.preload([:player1, :player2])
    resp = %{rooms: Phoenix.View.render_many(rooms, Dbs.RoomView, "room.json")}
    IO.inspect(resp)
    {:ok, resp, socket}
  end
  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end
end