defmodule MereWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `MereWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal MereWeb.YouTubeChannelLive.FormComponent,
        id: @you_tube_channel.id || :new,
        action: @live_action,
        you_tube_channel: @you_tube_channel,
        return_to: Routes.you_tube_channel_index_path(@socket, :index) %>
  """
  def live_modal(component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(MereWeb.ModalComponent, modal_opts)
  end

  def time_from_now(time) do
    Mere.Cldr.DateTime.Relative.to_string!(time, relative_to: DateTime.utc_now())
  end
end
