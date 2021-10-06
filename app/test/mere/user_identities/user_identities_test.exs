defmodule Mere.UserIdentitiesTest do
  alias Mere.{
    UserIdentities.UserIdentity
  }

  use Mere.DataCase, async: true

  describe "access_token_expired?/1" do
    test "false when not expired" do
      user_identity = %UserIdentity{access_token_expires_at: ~U[3015-01-23 23:50:07Z]}
      refute Mere.UserIdentities.access_token_expired?(user_identity)
    end

    test "true when expired" do
      user_identity = %UserIdentity{access_token_expires_at: ~U[2015-01-23 23:50:07Z]}
      assert Mere.UserIdentities.access_token_expired?(user_identity)
    end
  end

  describe "refresh_token_token_expired?/1" do
    test "false when not expired" do
      user_identity = %UserIdentity{refresh_token_expires_at: ~U[3015-01-23 23:50:07Z]}
      refute Mere.UserIdentities.refresh_token_expired?(user_identity)
    end

    test "true when not expired" do
      user_identity = %UserIdentity{refresh_token_expires_at: ~U[2015-01-23 23:50:07Z]}
      assert Mere.UserIdentities.refresh_token_expired?(user_identity)
    end
  end
end
