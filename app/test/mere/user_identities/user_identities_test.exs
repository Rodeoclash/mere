defmodule Mere.UsersTest do
  alias Mere.{
    Users
  }

  use Mere.DataCase, async: true

  describe "format_slug/1" do
    test "when already ok" do
      assert Users.format_slug("7sd") == "7sd"
    end

    test "when invalid" do
      assert Users.format_slug("7/s*&d") == "7sd"
    end

    test "underscores and dashes" do
      assert Users.format_slug("7-a_d") == "7ad"
    end
  end
end
