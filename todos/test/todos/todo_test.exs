defmodule Todos.TodoTest do
  use Todos.DataCase

  alias Todos.Todo

  import Todos.TodoFixtures

  describe "todo" do
    alias Todos.Todo.Item

    setup [:create_item]

    test "toggle_status/1 item.status 1 > 0", %{item: item} do
      assert item.status == 0

      # first toggle
      toggled_item = %{item | status: Todo.toggle_status(item)}
      assert toggled_item.status == 1

      # second toggle
      assert Todo.toggle_status(toggled_item) == 0
    end
  end

  describe "items" do
    alias Todos.Todo.Item

    @invalid_attrs %{person_id: nil, status: nil, text: nil}

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Todo.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Todo.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      valid_attrs = %{person_id: 42, status: 42, text: "some text"}

      assert {:ok, %Item{} = item} = Todo.create_item(valid_attrs)
      assert item.person_id == 42
      assert item.status == 42
      assert item.text == "some text"
    end

    test "create_item/1 sets appropriate default values" do
      valid_attrs = %{text: "some text"}

      assert {:ok, %Item{} = item} = Todo.create_item(valid_attrs)
      assert item.person_id == 0
      assert item.status == 0
      assert item.text == "some text"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Todo.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      update_attrs = %{person_id: 43, status: 43, text: "some updated text"}

      assert {:ok, %Item{} = item} = Todo.update_item(item, update_attrs)
      assert item.person_id == 43
      assert item.status == 43
      assert item.text == "some updated text"
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Todo.update_item(item, @invalid_attrs)
      assert item == Todo.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Todo.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Todo.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Todo.change_item(item)
    end
  end

  defp create_item(_) do
    item = item_fixture()
    %{item: item}
  end
end
