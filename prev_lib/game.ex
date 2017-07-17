defmodule Game do

  # def run do
  #   with player1 = create_player(1),
  #        player2 = create_player(2)
  #   do
  #     nil
  #   end
  # end

  # defp get_player(1) do
  #   %Player{name: "geospark"}
  # end
  # defp get_player(2) do
  #   %Player{name: "tuxagon"}
  # end

  # defp load_cards() do
  #   nil
  # end

  defp start_link, do: Agent.start_link(fn -> %{} end, name: :players)
  defp set_players do
    
  end
  defp stop, do: Agent.stop(:players)
end
