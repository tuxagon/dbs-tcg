defmodule Dbs.RoomView do
  use Dbs.Web, :view

  def render("room.json", %{room: room}) do
    %{
      id: room.id, 
      name: room.name, 
      players: [room.player1.name, room.player2.name]
    }
  end
end
