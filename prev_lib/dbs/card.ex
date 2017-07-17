defmodule Dbs.LeaderCard do
  defstruct [:name, :type]
end

defmodule Dbs.BattleCard do
  defstruct [:name, :type]
end

defmodule Dbs.ExtraCard do
  defstruct [:name, :type]
end
# defimpl Poison.Decoder, for: Dbs.Card do
#   def decode(%{type: type}, options) do
#     Poison.Decoder.decode()
#   end
# end