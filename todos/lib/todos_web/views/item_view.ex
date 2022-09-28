defmodule TodosWeb.ItemView do
  use TodosWeb, :view

  def complete(item) do
    case item.status do
      1 -> "completed"
      _ -> ""
    end
  end

  def checked(item) do
    case item.status do
      1 -> "checked"
      _ -> ""
    end
  end

  def remaining_items(items) do
    Enum.count(items, fn i -> i.status == 0 end)
  end

  def filter(items, filter_string) do
    case filter_string do
      "active" -> Enum.filter(items, fn item -> item.status != 1 end)
      "completed" -> Enum.filter(items, fn item -> item.status == 1 end)
      _ -> items
    end
  end

  def selected(filter, str) do
    case filter == str do
      true -> "selected"
      false -> ""
    end
  end
end
