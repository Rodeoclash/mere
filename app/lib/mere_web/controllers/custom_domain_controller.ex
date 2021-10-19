defmodule MereWeb.CustomDomainController do
  alias Mere.{
    CustomDomains.CustomDomain,
    Repo
  }

  use MereWeb, :controller

  def index(%{assigns: %{current_user: current_user}} = conn, _params) do
    conn
    |> assign(:custom_domains, custom_domains(current_user))
    |> assign(:changeset, empty_changeset(current_user))
    |> render("index.html")
  end

  def create(%{assigns: %{current_user: current_user}} = conn, %{
        "custom_domain" => new_custom_domain
      }) do
    changeset =
      CustomDomain.changeset(
        %CustomDomain{
          user_id: current_user.id
        },
        new_custom_domain
      )

    case Repo.insert(changeset) do
      {:ok, custom_domain} ->
        conn
        |> assign(:custom_domains, custom_domains(current_user))
        |> assign(:changeset, empty_changeset(current_user))
        |> put_flash(:info, "Custom domain created")
        |> render("index.html")

      {:error, changeset} ->
        conn
        |> assign(:custom_domains, custom_domains(current_user))
        |> assign(:changeset, changeset)
        |> put_flash(:error, "Error adding custom domain")
        |> render("index.html")
    end
  end

  def delete(%{assigns: %{current_user: current_user}} = conn, %{"id" => id}) do
    custom_domain =
      Repo.get_by(CustomDomain, %{
        user_id: current_user.id,
        id: id
      })

    case Repo.delete(custom_domain) do
      {:ok, custom_domain} ->
        conn
        |> assign(:custom_domains, custom_domains(current_user))
        |> assign(:changeset, empty_changeset(current_user))
        |> put_flash(:info, "Custom domain deleted")
        |> render("index.html")

      {:error, changeset} ->
        conn
        |> assign(:custom_domains, custom_domains(current_user))
        |> assign(:changeset, changeset)
        |> put_flash(:error, "Error deleting custom domain")
        |> render("index.html")
    end
  end

  defp custom_domains(current_user) do
    CustomDomain.where_user_id_query(current_user.id)
    |> Repo.all()
  end

  defp empty_changeset(current_user) do
    CustomDomain.changeset(%CustomDomain{
      user_id: current_user.id
    })
  end
end
