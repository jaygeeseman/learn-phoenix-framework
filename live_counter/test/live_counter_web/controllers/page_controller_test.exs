defmodule LiveCounterWeb.PageControllerTest do
@moduledoc """
Nothing to see here
"""
  use LiveCounterWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "The count is"
  end
end
