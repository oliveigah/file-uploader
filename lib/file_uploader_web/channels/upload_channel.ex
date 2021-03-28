defmodule FileUploaderWeb.UploadChannel do
  use Phoenix.Channel

  def join("file_upload:" <> client_id, _message, socket) do
    {:ok, socket}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    broadcast!(socket, "new_msg", %{body: body})
    {:noreply, socket}
  end

  def handle_in("new_error", {:error, messages, line}, socket) do
    broadcast!(socket, "new_error", %{body: %{message: messages, line: line}})
    {:noreply, socket}
  end
end
