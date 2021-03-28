defmodule FileUploaderWeb.PageController do
  use FileUploaderWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, %{"input_file" => %{path: temp_path, filename: file_name}}) do
    {:ok, file} = File.read(temp_path)
    File.write("repository/1/sample.csv", file)
    spawn(fn -> FileUploader.read_file(1, "sample.csv") end)
    render(conn, "validation.html", file_name: file_name)
  end
end
