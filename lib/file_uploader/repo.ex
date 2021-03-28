defmodule FileUploader.Repo do
  use Ecto.Repo,
    otp_app: :file_uploader,
    adapter: Ecto.Adapters.MyXQL
end
