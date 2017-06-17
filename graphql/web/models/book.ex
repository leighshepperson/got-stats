defmodule GOTStats.GraphQL.Models.Book do
  defstruct [
    :url,
    :name,
    :isbn,
    :authors,
    :number_of_pages,
    :publisher,
    :country,
    :media_type,
    :released,
    :characters,
    :pov_characters
  ]
end
