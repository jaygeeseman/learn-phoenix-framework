defmodule TodosWeb.ItemControllerTest do
  use TodosWeb.ConnCase

  import Todos.TodoFixtures

  @create_attrs %{person_id: 42, status: 42, text: "some text"}
  @update_attrs %{person_id: 43, status: 43, text: "some updated text"}
  @invalid_attrs %{person_id: nil, status: nil, text: nil}

  describe "index" do
    test "lists all items", %{conn: conn} do
      conn = get(conn, Routes.item_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Items"
    end
  end

  describe "new item" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.item_path(conn, :new))
      assert html_response(conn, 200) =~ "New Item"
    end
  end

  describe "create item" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.item_path(conn, :create), item: @create_attrs)

      assert redirected_to(conn) == Routes.item_path(conn, :index)
      assert html_response(conn, 302) =~ "redirected"

      conn = get(conn, Routes.item_path(conn, :index))
      assert html_response(conn, 200) =~ @create_attrs.text
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.item_path(conn, :create), item: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Item"
    end
  end

  describe "edit item" do
    setup [:create_item]

    test "renders form for editing chosen item", %{conn: conn, item: item} do
      conn = get(conn, Routes.item_path(conn, :edit, item))
      assert html_response(conn, 200) =~ item.text
    end
  end

  describe "update item" do
    setup [:create_item]

    test "redirects when data is valid", %{conn: conn, item: item} do
      conn = put(conn, Routes.item_path(conn, :update, item), item: @update_attrs)
      assert redirected_to(conn) == Routes.item_path(conn, :index)

      conn = get(conn, Routes.item_path(conn, :show, item))
      assert html_response(conn, 200) =~ "some updated text"
    end

    test "renders errors when data is invalid", %{conn: conn, item: item} do
      conn = put(conn, Routes.item_path(conn, :update, item), item: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Item"
    end
  end

  describe "delete item" do
    setup [:create_item]

    test "deletes chosen item", %{conn: conn, item: item} do
      conn = delete(conn, Routes.item_path(conn, :delete, item))
      assert redirected_to(conn) == Routes.item_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.item_path(conn, :show, item))
      end
    end
  end

  describe "toggle_status updates the status of an item" do
    setup [:create_item]

    test "toggle_status/1 item.status 1 > 0", %{item: item} do
      assert item.status == 0

      # first toggle
      toggled_item = %{item | status: TodosWeb.ItemController.toggle_status(item)}
      assert toggled_item.status == 1

      # second toggle
      assert TodosWeb.ItemController.toggle_status(toggled_item) == 0
    end

    test "toggle/2 (toggle endpoint) updates an item.status 0 > 1", %{conn: conn, item: item} do
      assert item.status == 0

      # first toggle
      get(conn, Routes.item_path(conn, :toggle, item.id))
      toggled_item = Todos.Todo.get_item!(item.id)
      assert toggled_item.status == 1

      # second toggle
      get(conn, Routes.item_path(conn, :toggle, item.id))
      toggled_item = Todos.Todo.get_item!(item.id)
      assert toggled_item.status == 0
    end
  end

  defp create_item(_) do
    item = item_fixture()
    %{item: item}
  end
end
