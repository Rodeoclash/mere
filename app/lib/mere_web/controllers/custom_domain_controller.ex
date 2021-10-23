defmodule MereWeb.CustomDomainController do
  alias Mere.{
    CustomDomains.CustomDomain,
    Fly.Queries,
    Jobs,
    Repo
  }

  use MereWeb, :controller

  @page_title "Custom Domains"

  def index(%{assigns: %{current_user: current_user}} = conn, _params) do
    conn
    |> assign(:changeset, get_empty_changeset(current_user))
    |> populate_conn(current_user)
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
        hostname = new_custom_domain["hostname"]

        Queries.Certificates.create(hostname)

        %{"hostname" => hostname}
        |> Jobs.PingCustomDomain.new()
        |> Oban.insert()

        conn
        |> put_flash(:info, "Custom domain #{custom_domain.hostname} creating")
        |> redirect(to: Routes.custom_domain_path(MereWeb.Endpoint, :index))

      {:error, changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> put_flash(:error, "Error adding custom domain")
        |> populate_conn(current_user)
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
        IO.inspect(Queries.Certificates.delete(custom_domain.hostname))

        conn
        |> put_flash(:info, "Custom domain #{custom_domain.hostname} deleted")
        |> redirect(to: Routes.custom_domain_path(MereWeb.Endpoint, :index))

      {:error, changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> put_flash(:error, "Error deleting custom domain")
        |> populate_conn(current_user)
    end
  end

  defp populate_conn(conn, current_user) do
    conn
    |> assign(:custom_domains, get_custom_domains(current_user))
    |> assign(:custom_domains_status, get_custom_domains_status())
    |> assign(:page_title, @page_title)
    |> render("index.html")
  end

  defp get_custom_domains(current_user) do
    CustomDomain.where_user_id_query(current_user.id)
    |> Repo.all()
  end

  defp get_empty_changeset(current_user) do
    CustomDomain.changeset(%CustomDomain{
      user_id: current_user.id
    })
  end

  defp get_custom_domains_status() do
    case Queries.Certificates.get() do
      {:ok, response} ->
        response.body
        |> get_in(["data", "app", "certificates", "nodes"])
        |> Map.new(fn node ->
          {
            node["hostname"],
            node["clientStatus"]
          }
        end)

      {:error, _reason} ->
        %{}
    end
  end
end
