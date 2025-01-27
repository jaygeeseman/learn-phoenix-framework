defmodule TodosWeb.ItemControllerTest do
  use TodosWeb.ConnCase

  import Todos.TodoFixtures

  @create_attrs %{person_id: 42, status: 42, text: "some text"}
  @update_attrs %{person_id: 43, status: 43, text: "some updated text"}
  @invalid_attrs %{person_id: nil, status: nil, text: nil}

  describe "index" do
    test "lists all items", %{conn: conn} do
      conn = get(conn, Routes.item_path(conn, :index))
      assert html_response(conn, 200) =~ "todos"
    end
  end

  describe "filters" do
    setup [:create_filter_items]

    test "with no filter shows all items", %{conn: conn, items: items} do
      conn = get(conn, Routes.item_path(conn, :index))
      Enum.each(items, fn item -> assert html_response(conn, 200) =~ item.text end)
    end

    test "with \"active\" filter shows items with status 0", %{conn: conn, items: items} do
      conn = get(conn, Routes.item_path(conn, :index, filter: "active"))
      Enum.each(items,
        fn item ->
          case item.status do
            1 -> refute html_response(conn, 200) =~ item.text
            _ -> assert html_response(conn, 200) =~ item.text
          end
        end)
    end

    test "with \"completed\" filter shows items with status 1", %{conn: conn, items: items} do
      conn = get(conn, Routes.item_path(conn, :index, filter: "completed"))
      Enum.each(items,
        fn item ->
          case item.status do
            1 -> assert html_response(conn, 200) =~ item.text
            _ -> refute html_response(conn, 200) =~ item.text
          end
        end)
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

  describe "clear completed items" do
    setup [:create_filter_items]

    test "deletes items with status 1", %{conn: conn, items: items} do
      conn = get(conn, Routes.item_path(conn, :clear_completed))

      assert redirected_to(conn) == Routes.item_path(conn, :index)
      assert html_response(conn, 302) =~ "redirected"

      conn = get(conn, Routes.item_path(conn, :index))
      Enum.each(items,
        fn item ->
          case item.status do
            1 -> refute html_response(conn, 200) =~ item.text
            _ -> assert html_response(conn, 200) =~ item.text
          end
        end)
    end
  end

  describe "toggle updates the status of an item" do
    setup [:create_item]

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

  defp create_filter_items(_) do
    item1 = item_fixture(%{status: 0, text: "item one"})
    item2 = item_fixture(%{status: 1, text: "item two"})
    %{items: [item1, item2]}
  end
end
