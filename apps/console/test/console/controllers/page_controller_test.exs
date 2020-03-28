defmodule Console.PageControllerTest do
  use Console.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to your classroom library."
  end
end
