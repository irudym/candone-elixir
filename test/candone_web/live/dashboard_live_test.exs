defmodule CandoneWeb.DashboardLiveTest do
  use CandoneWeb.ConnCase

  import Phoenix.LiveViewTest
  import Candone.DashboardsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_dashboard(_) do
    dashboard = dashboard_fixture()
    %{dashboard: dashboard}
  end

  describe "Index" do
    setup [:create_dashboard]

    test "lists all dashboard", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.dashboard_index_path(conn, :index))

      assert html =~ "Listing Dashboard"
    end

    test "saves new dashboard", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.dashboard_index_path(conn, :index))

      assert index_live |> element("a", "New Dashboard") |> render_click() =~
               "New Dashboard"

      assert_patch(index_live, Routes.dashboard_index_path(conn, :new))

      assert index_live
             |> form("#dashboard-form", dashboard: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#dashboard-form", dashboard: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.dashboard_index_path(conn, :index))

      assert html =~ "Dashboard created successfully"
    end

    test "updates dashboard in listing", %{conn: conn, dashboard: dashboard} do
      {:ok, index_live, _html} = live(conn, Routes.dashboard_index_path(conn, :index))

      assert index_live |> element("#dashboard-#{dashboard.id} a", "Edit") |> render_click() =~
               "Edit Dashboard"

      assert_patch(index_live, Routes.dashboard_index_path(conn, :edit, dashboard))

      assert index_live
             |> form("#dashboard-form", dashboard: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#dashboard-form", dashboard: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.dashboard_index_path(conn, :index))

      assert html =~ "Dashboard updated successfully"
    end

    test "deletes dashboard in listing", %{conn: conn, dashboard: dashboard} do
      {:ok, index_live, _html} = live(conn, Routes.dashboard_index_path(conn, :index))

      assert index_live |> element("#dashboard-#{dashboard.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#dashboard-#{dashboard.id}")
    end
  end

  describe "Show" do
    setup [:create_dashboard]

    test "displays dashboard", %{conn: conn, dashboard: dashboard} do
      {:ok, _show_live, html} = live(conn, Routes.dashboard_show_path(conn, :show, dashboard))

      assert html =~ "Show Dashboard"
    end

    test "updates dashboard within modal", %{conn: conn, dashboard: dashboard} do
      {:ok, show_live, _html} = live(conn, Routes.dashboard_show_path(conn, :show, dashboard))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Dashboard"

      assert_patch(show_live, Routes.dashboard_show_path(conn, :edit, dashboard))

      assert show_live
             |> form("#dashboard-form", dashboard: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#dashboard-form", dashboard: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.dashboard_show_path(conn, :show, dashboard))

      assert html =~ "Dashboard updated successfully"
    end
  end
end
