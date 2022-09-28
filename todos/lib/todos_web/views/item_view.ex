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
      1 -> true
      _ -> false
    end
  end

  def remaining_items(items) do
    Enum.count(items, fn i -> i.status == 0 end)
  end
end
