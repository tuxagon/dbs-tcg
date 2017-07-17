defmodule Skill do
  @derive [Poison.Encoder]
  defstruct [:keywords, :text]
end