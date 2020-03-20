defmodule Console.CardController do
  use Console, :controller

  def index(conn, _params) do
    render(conn, "index.html", cards: Checkout.Cards.list_all())
  end

  def show(conn, %{"id" => id}) do
    %{first_name: first_name, last_name: last_name} =
      Checkout.Cards.lookup_by_id(id)
    render(
      conn,
      "show.html",
      [id: id, first_name: first_name, last_name: last_name]
    )
  end
end
