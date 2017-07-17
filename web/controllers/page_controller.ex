defmodule DbsTcg.PageController do
  use DbsTcg.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
