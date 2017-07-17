defmodule Dbs.CardLibrary do
  def start_link do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def get_all do
    case Agent.get(__MODULE__, fn ls -> ls end) do
      [] ->
        Agent.update(__MODULE__, fn _ -> load_cards() end)
        get_all()

      cards ->
        cards
    end
  end

  def stop do
    Agent.stop(__MODULE__)
  end

  defp load_cards do
    result = File.read!("lib/dbs/cards.json")
    cards = Enum.map(Poison.decode!(result), fn card ->
      map = for {key,val} <- card, into: %{}, do: {String.to_atom(key), val}
      case String.downcase(map[:type]) do
        "leader" -> struct(Dbs.LeaderCard, map)
        "battle" -> struct(Dbs.BattleCard, map)
        "extra" -> struct(Dbs.ExtraCard, map)
        _ -> nil
      end
    end)
    Enum.filter(cards, &(&1 != nil))
  end
end