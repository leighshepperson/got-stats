defmodule GOTStats.GraphQL.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema
  alias GOTStats.GraphQL.Adapters.IceAndFire
  alias GOTStats.GraphQL.Models.{Book, Root, Character}

  node interface do
    resolve_type fn
      %Root{}, _ -> :root
      %Book{}, _ -> :book
      %Character{}, _ -> :character
      _, _ ->  nil
    end
  end

  node object :book do
    field :url, :string
    field :name, :string
    field :isbn, :string
    field :authors, list_of(:string)
    field :number_of_pages, :integer
    field :publisher, :string
    field :country, :string
    field :media_type, :string
    field :released, :string
    connection field :characters, node_type: :character do
      resolve fn
        pagination_args, %{source: %{characters: characters}} ->
          connection = Absinthe.Relay.Connection.from_list(
            IceAndFire.get_characters(characters), pagination_args
          )
          {:ok, connection}
        end
    end
    connection field :pov_characters, node_type: :character do
      resolve fn
        pagination_args, %{source: %{pov_characters: pov_characters}} ->
          connection = Absinthe.Relay.Connection.from_list(
            IceAndFire.get_characters(pov_characters), pagination_args
          )
          {:ok, connection}
        end
    end
  end

  node object :character do
    field :url, :string
    field :name, :string
    field :gender, :string
    field :culture, :string
    field :born, :string
    field :died, :string
    field :titles, list_of(:string)
    field :aliases, list_of(:string)
    field :father, :string
    field :mother, :string
    field :spouce, :string
    field :allegiances, list_of(:string)
    field :books, list_of(:string)
    field :pov_books, list_of(:string)
    field :tv_series, list_of(:string)
    field :played_by, :string
  end

  node object :house do
    field :url, :string
    field :name, :string
    field :region, :string
    field :coat_of_arms, :string
    field :words, :string
    field :titles, list_of(:string)
    field :seats, list_of(:string)
    field :current_lord, :string
    field :heir, :string
    field :overlord, :string
    field :founded, :string
    field :founder, :string
    field :died_out, :string
    field :ancestrial_weapons, list_of(:string)
    field :cadet_branches, list_of(:string)
    field :sword_members, list_of(:string)
  end

  node object :root do
    connection field :books, node_type: :book do
      resolve fn
        pagination_args, %{source: _root} ->
          connection = Absinthe.Relay.Connection.from_list(
            IceAndFire.get_books(), pagination_args
          )
          {:ok, connection}
        end
    end
  end

  connection node_type: :book
  connection node_type: :character

  query do
    field :root, :root do
      resolve fn(_,_) -> {:ok, %Root{id: 1}} end
    end
    node field do
      resolve fn
        %{type: :root, id: id}, _ -> {:ok, %Root{id: id}}
        %{type: :character, id: id}, _ -> {:ok, IceAndFire.get_character(id)}
      end
    end
  end

end
