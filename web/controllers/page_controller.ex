defmodule Dbs.PageController do
  use Dbs.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
