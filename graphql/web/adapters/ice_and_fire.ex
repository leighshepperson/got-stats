defmodule GOTStats.GraphQL.Adapters.IceAndFire do
  use GOTStats.GraphQL.Cache
  alias Task.Supervisor
  alias GOTStats.GraphQL.Models.{Book, Character}
  alias GOTStats.GraphQL.TaskSupervisor
  @endpoint "https://www.anapioficeandfire.com/api/"

  def get_books() do
    get_books("books")
  end

  defcache get_books("books") do
    {:ok, %{body: body}} = HTTPoison.get("#{@endpoint}/books")
    body
    |> Poison.decode!
    |> Enum.map(& struct(Book, to_native_map(&1)))
    |> set_id_to_url
  end

  defcache get_character(url) do
    {:ok, %{body: body}} = HTTPoison.get(url)

    decoded_body = body
    |> Poison.decode!
    |> to_native_map

    struct(Character, decoded_body)
    |> set_id_to_url
  end

  def get_characters(urls) do
    urls
    |> Enum.map(fn url -> create_fetch_task(url, &get_character/1) end)
    |> Enum.map(&Task.await(&1))
  end

  defcache get_house(url) do
    {:ok, %{body: body}} = HTTPoison.get(url)

    decoded_body = body
    |> Poison.decode!
    |> to_native_map

    struct(House, decoded_body)
    |> set_id_to_url
  end

  def get_houses(urls) do
    urls
    |> Enum.map(fn url -> create_fetch_task(url, &get_house/1) end)
    |> Enum.map(&Task.await(&1))
  end

  defp create_fetch_task(url, fun) do
    Supervisor.async_nolink(TaskSupervisor, fn -> fun.(url) end)
  end

  defp to_native_map(string_key_map) do
    for {key, val} <- string_key_map, into: %{}, do: {(String.to_atom(Macro.underscore(key))), val}
  end

  defp set_id_to_url(maps) when is_list(maps) do
    maps
    |> Enum.map(&set_id_to_url(&1))
  end

  defp set_id_to_url(map) do
    map
    |> Map.update(:id, -1, fn _ -> map.url end)
  end

end
