defmodule Console.CardView do
  use Console, :view

  def generate_barcode(id) do
    {:ok, data} = Barlix.Code128.encode!(id) |> Barlix.PNG.print()
    "data:image/png;base64,#{IO.iodata_to_binary(data) |> Base.encode64()}"
  end
end
