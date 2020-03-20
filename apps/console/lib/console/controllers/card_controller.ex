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

  defp next(conn, "true") do
    new(conn, nil)
  end

  defp next(conn, "false") do
    index(conn, nil)
  end

  def delete(conn, %{"id" => id}) do
    Checkout.Cards.remove_by_id(id)
    index(conn, nil)
  end

  def edit(conn, %{"id" => id}) do
    card = Checkout.Cards.lookup_by_id(id)
    render(conn, "edit.html", id: id, card: card)
  end

  def update(
        conn,
        %{
          "card" => %{
            "first_name" => first_name,
            "last_name" => last_name
          },
          "id" => id
        }
      ) do
    Checkout.Cards.update_field_by_id(id, :first_name, first_name)
    Checkout.Cards.update_field_by_id(id, :last_name, last_name)
    index(conn, nil)
  end
end
