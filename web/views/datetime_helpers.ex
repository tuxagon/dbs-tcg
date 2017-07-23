defmodule Dbs.DateTimeHelpers do
  def from_iso8601_to_unix(str) do
    str
    #|> DateTime.from_iso8601()
    #|> DateTime.to_unix()
  end
end