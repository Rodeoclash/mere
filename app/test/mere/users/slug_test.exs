defmodule Mere.Users.SlugTest do
  alias Mere.{
    Users.Slug
  }

  use Mere.DataCase, async: true

  describe "format/1" do
    test "when already ok" do
      assert Slug.format("7sd") == "7sd"
    end

    test "when invalid" do
      assert Slug.format("7/s*&d") == "7sd"
    end

    test "underscores and dashes" do
      assert Slug.format("infernal-hamster") == "infernal-hamster"
    end
  end
end
