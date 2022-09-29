defmodule TodosWeb.ItemController do
  use TodosWeb, :controller

  alias Todos.Todo
  alias Todos.Todo.Item

  def index(conn, params) do
    item = if not is_nil(params) and Map.has_key?(params, "id") do
      Todo.get_item!(params["id"])
    else
      %Item{}
    end

    items = Todo.list_items()
    changeset = Todo.change_item(item)
    render(conn, "index.html",
      items: items,
      changeset: changeset,
      editing: item,
      filter: Map.get(params, "filter", "all"))
  end

  def new(conn, _params) do
    changeset = Todo.change_item(%Item{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"item" => item_params}) do
    case Todo.create_item(item_params) do
      {:ok, _item} ->
        conn
        |> put_flash(:info, "Item created successfully.")
        |> redirect(to: Routes.item_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    item = Todo.get_item!(id)
    render(conn, "show.html", item: item)
  end

  def edit(conn, params) do
    index(conn, params)
  end

  def update(conn, %{"id" => id, "item" => item_params}) do
    item = Todo.get_item!(id)

    case Todo.update_item(item, item_params) do
      {:ok, _} ->
        redirect(conn, to: Routes.item_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", item: item, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    item = Todo.get_item!(id)
    {:ok, _item} = Todo.delete_item(item)

    conn
    |> put_flash(:info, "Item deleted successfully.")
    |> redirect(to: Routes.item_path(conn, :index))
  end

  def clear_completed(conn, _) do
    items = Todo.list_items()
    Enum.filter(items, fn item -> item.status == 1 end)
    |> Enum.each(fn item -> Todo.delete_item(item) end)
    redirect(conn, to: Routes.item_path(conn, :index))
  end

  def toggle(conn, %{"id" => id}) do
    item = Todo.get_item!(id)
    Todo.update_item(item, %{status: toggle_status(item)})
    redirect(conn, to: Routes.item_path(conn, :index))
  end

  def toggle_status(item) do
    if item.status == 0, do: 1, else: 0
  end
end
