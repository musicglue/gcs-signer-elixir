defmodule GcsSigner.Client do
  @moduledoc """
  Holds Google Cloud Service Account JSON
  """

  defstruct private_key: nil, client_email: nil

  @doc """
  Initialize GcsSigner.Client

  ## Examples

      iex> service_account = service_account_json_str |> Poison.decode!
      iex> GcsSigner.Client.init(service_account_map)
      %GcsSigner.Client{...}


      # Load from env variables
      iex> GcsSigner.Client.init()
      %GcsSigner.Client{...}

  """
  def init() do
    case look_for_environment_variables() do
      nil ->
        raise "You to configure GcsSigner - either using GOOGLE_CLOUD_KEYFILE / GOOGLE_CLOUD_KEYFILE_JSON or by using app env"

      data ->
        data |> Poison.decode!() |> from_keyfile()
    end
  end

  def init(keyfile_map) when is_map(keyfile_map), do: from_keyfile(keyfile_map)

  defp from_keyfile(%{
         "private_key" => private_key,
         "client_email" => client_email
       }) do
    %GcsSigner.Client{
      private_key: private_key,
      client_email: client_email
    }
  end

  defp look_for_environment_variables() do
    case System.fetch_env("GOOGLE_CLOUD_KEYFILE") do
      {:ok, keyfile} ->
        keyfile |> File.read!()

      _ ->
        System.get_env("GOOGLE_CLOUD_KEYFILE_JSON")
    end
  end
end
