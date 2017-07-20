defmodule UnityGs.PageController do
  use UnityGs.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
