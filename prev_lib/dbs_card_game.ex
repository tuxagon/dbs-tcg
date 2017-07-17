defmodule DbsCardGame do
  @moduledoc """
  Documentation for DbsCardGame.
  """

  @doc """
  Hello world.

  ## Examples

      iex> DbsCardGame.hello
      :world

  """
  def load_cards do
    with result = File.read!("lib/cards.json")
    do
      Poison.decode!(result, as: [%Card{skills: [%Skill{}]}])
    end
  end
end
