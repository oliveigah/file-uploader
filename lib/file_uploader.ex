defmodule FileUploader do
  def read_file(client_id, file_type) do
    Path.absname("repository/#{client_id}/#{file_type}")
    |> File.stream!()
    |> CSV.decode(headers: true)
    |> Stream.map(&validate_line/1)
    |> Stream.with_index(1)
    |> Stream.map(fn {{status, data}, line_number} -> {status, data, line_number} end)
    |> Enum.each(&notify_client(&1, client_id))
  end

  defp validate_line({:ok, line_data}) do
    error_list =
      Stream.map(line_data, &validate_field/1)
      |> Stream.filter(fn {status, _data} -> status == :error end)
      |> Enum.map(fn {_, error_message} -> error_message end)

    case error_list do
      [] ->
        {:ok, line_data}

      error_list ->
        {:error, error_list}
    end
  end

  defp validate_field({"avaliacao", value}) do
    case value do
      "1" ->
        {:error, "Campo avaliacao não pode ser 1"}

      valid_data ->
        {:ok, valid_data}
    end
  end

  defp validate_field({"nome", value}) do
    case value do
      "Ana" ->
        {:error, "Não pode se chamar Ana"}

      valid_data ->
        {:ok, valid_data}
    end
  end

  defp validate_field(valid_data) do
    {:ok, valid_data}
  end

  defp notify_client(data, client_id) do
    case data do
      {:ok, _valid_data, line} ->
        :timer.sleep(500)

        FileUploaderWeb.Endpoint.broadcast(
          "file_upload:#{client_id}",
          "inserted_line",
          %{body: %{message: "Inserted line #{line}"}}
        )

      {:error, messages, line} ->
        FileUploaderWeb.Endpoint.broadcast(
          "file_upload:#{client_id}",
          "new_error",
          %{body: %{message: messages, line: line}}
        )
    end
  end
end
