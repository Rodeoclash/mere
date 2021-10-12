defmodule MereWeb.PageController do
  use MereWeb, :controller

  # Marketing homepage
  def index(%{assigns: %{user: nil}} = conn, _params) do
    conn
    |> render("index.html")
  end

  # User homepage
  def index(%{assigns: %{user: _user}} = conn, _params) do
    conn
    |> render("user.html")
  end
end
