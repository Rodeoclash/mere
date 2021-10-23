defmodule MereWeb.PageControllerTest do
  use MereWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Social Eyes"
  end
end
