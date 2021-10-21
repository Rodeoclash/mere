defmodule MereWeb.CurrentUserController do
  alias Mere.{
    Repo,
    Users.User
  }

  use MereWeb, :controller

  @page_title "Profile / Theme"

  def edit(%{assigns: %{current_user: current_user}} = conn, _params) do
    changeset = User.changeset(current_user)

    conn
    |> assign(:page_title, @page_title)
    |> assign(:changeset, changeset)
    |> render("edit.html")
  end

  def update(
        %{assigns: %{current_user: current_user}} = conn,
        %{"user" => updated_current_user}
      ) do
    changeset = User.changeset(current_user, updated_current_user)

    case Repo.update(changeset) do
      {:ok, _current_user} ->
        conn
        |> put_flash(:info, "Details updated")
        |> redirect(to: Routes.current_user_path(conn, :edit))

      {:error, failed_changeset} ->
        conn
        |> put_flash(:error, "Problem updating your details")
        |> assign(:page_title, @page_title)
        |> assign(:changeset, changeset)
        |> render("edit.html", changeset: failed_changeset)
    end
  end
end
