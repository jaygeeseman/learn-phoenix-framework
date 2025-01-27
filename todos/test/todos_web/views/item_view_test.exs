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
    assert ItemView.checked(%{status: 1}) == "checked"
  end

  test "checked/1 returns false if item.status == 0" do
    assert ItemView.checked(%{status: 0}) == ""
  end

  test "remaining_items/1 returns count of items where item.status==0" do
    items = [
      %{text: "one", status: 0},
      %{text: "two", status: 0},
      %{text: "three", status: 1}
    ]

    assert ItemView.remaining_items(items) == 2
  end

  test "remaining_items/1 returns 0 (zero) when no items are status==0" do
    assert ItemView.remaining_items([]) == 0
  end

  test "filter/2 returns filtered items properly" do
    items = [
      %{text: "one", status: 0},
      %{text: "two", status: 0},
      %{text: "three", status: 1}
    ]

    assert ItemView.filter(items, "all") == items
    assert ItemView.filter(items, "active") == [Enum.at(items, 0), Enum.at(items, 1)]
    assert ItemView.filter(items, "completed") == [Enum.at(items, 2)]
  end
end
