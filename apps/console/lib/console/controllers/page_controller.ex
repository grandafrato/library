defmodule Console.PageController do
  use Console, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
