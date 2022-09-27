defmodule TodosWeb.ItemViewTest do
  use TodosWeb.ConnCase, async: true
  alias TodosWeb.ItemView

  test "complete/1 returns completed if item.status == 1" do
    assert ItemView.complete(%{status: 1}) == "completed"
  end

  test "complete/1 returns empty string if item.status == 0" do
    assert ItemView.complete(%{status: 0}) == ""
  end

  test "checked/1 returns true if item.status == 1" do
    assert ItemView.checked(%{status: 1}) == true
  end

  test "checked/1 returns false if item.status == 0" do
    assert ItemView.checked(%{status: 0}) == false
  end
end
