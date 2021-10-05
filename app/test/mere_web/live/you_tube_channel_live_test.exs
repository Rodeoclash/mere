defmodule MereWeb.YouTubeChannelLiveTest do
  use MereWeb.ConnCase

  import Phoenix.LiveViewTest
  import Mere.YouTubeChannelsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_you_tube_channel(_) do
    you_tube_channel = you_tube_channel_fixture()
    %{you_tube_channel: you_tube_channel}
  end

  describe "Index" do
    setup [:create_you_tube_channel]

    test "lists all youtube_channels", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.you_tube_channel_index_path(conn, :index))

      assert html =~ "Listing Youtube channels"
    end

    test "saves new you_tube_channel", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.you_tube_channel_index_path(conn, :index))

      assert index_live |> element("a", "New You tube channel") |> render_click() =~
               "New You tube channel"

      assert_patch(index_live, Routes.you_tube_channel_index_path(conn, :new))

      assert index_live
             |> form("#you_tube_channel-form", you_tube_channel: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#you_tube_channel-form", you_tube_channel: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.you_tube_channel_index_path(conn, :index))

      assert html =~ "You tube channel created successfully"
    end

    test "updates you_tube_channel in listing", %{conn: conn, you_tube_channel: you_tube_channel} do
      {:ok, index_live, _html} = live(conn, Routes.you_tube_channel_index_path(conn, :index))

      assert index_live |> element("#you_tube_channel-#{you_tube_channel.id} a", "Edit") |> render_click() =~
               "Edit You tube channel"

      assert_patch(index_live, Routes.you_tube_channel_index_path(conn, :edit, you_tube_channel))

      assert index_live
             |> form("#you_tube_channel-form", you_tube_channel: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#you_tube_channel-form", you_tube_channel: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.you_tube_channel_index_path(conn, :index))

      assert html =~ "You tube channel updated successfully"
    end

    test "deletes you_tube_channel in listing", %{conn: conn, you_tube_channel: you_tube_channel} do
      {:ok, index_live, _html} = live(conn, Routes.you_tube_channel_index_path(conn, :index))

      assert index_live |> element("#you_tube_channel-#{you_tube_channel.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#you_tube_channel-#{you_tube_channel.id}")
    end
  end

  describe "Show" do
    setup [:create_you_tube_channel]

    test "displays you_tube_channel", %{conn: conn, you_tube_channel: you_tube_channel} do
      {:ok, _show_live, html} = live(conn, Routes.you_tube_channel_show_path(conn, :show, you_tube_channel))

      assert html =~ "Show You tube channel"
    end

    test "updates you_tube_channel within modal", %{conn: conn, you_tube_channel: you_tube_channel} do
      {:ok, show_live, _html} = live(conn, Routes.you_tube_channel_show_path(conn, :show, you_tube_channel))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit You tube channel"

      assert_patch(show_live, Routes.you_tube_channel_show_path(conn, :edit, you_tube_channel))

      assert show_live
             |> form("#you_tube_channel-form", you_tube_channel: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#you_tube_channel-form", you_tube_channel: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.you_tube_channel_show_path(conn, :show, you_tube_channel))

      assert html =~ "You tube channel updated successfully"
    end
  end
end
