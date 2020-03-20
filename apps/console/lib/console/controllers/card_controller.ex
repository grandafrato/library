defmodule Console.CardController do
  use Console, :controller

  def index(conn, _params) do
    render(conn, "index.html", cards: Checkout.Cards.list_all())
  end

  def show(conn, %{"id" => id}) do
    card = Checkout.Cards.lookup_by_id(id)

    render(
      conn,
      "show.html",
      id: id,
      card: card
    )
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(
        conn,
        %{
          "card" => %{
            "first_name" => first_name,
            "last_name" => last_name,
            "enter_another?" => another
          }
        }
      ) do
    Checkout.Cards.add(Checkout.Cards.Card.new(first_name, last_name))
    next(conn, another)
  end

  def next(conn, "true") do
    new(conn, nil)
  end

  def next(conn, "false") do
    index(conn, nil)
  end
end
