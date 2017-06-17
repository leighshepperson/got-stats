defmodule GOTStats.GraphQL.Cache do
  alias GOTStats.GraphQL.Cache

  defmacro __using__(_options) do
    quote location: :keep do
      import GOTStats.GraphQL.Cache, only: [defcache: 2]
    end
  end

  defmacro defcache({name, _meta, [key|_] = params}, do: body) do
    quote do
      def unquote(name)(unquote_splicing(params)) do
        Cache.fetch(unquote(key), fn -> unquote(body) end)
      end
    end
  end

  def fetch(key, fallback) do
    Cachex.get!(:got_stats_cachex, key, fallback: fn(_key) -> fallback.() end)
  end
end
