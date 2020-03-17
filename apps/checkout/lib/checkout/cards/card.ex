defmodule Checkout.Cards.Card do
  @enforce_keys [:id]
  defstruct [:id, :first_name, :last_name, checked_out_books: []]

  def new(first_name, last_name) do
    %__MODULE__{
      id: UUID.uuid1(),
      first_name: first_name,
      last_name: last_name
    }
  end
end
