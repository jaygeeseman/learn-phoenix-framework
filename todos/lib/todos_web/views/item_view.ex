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
end
