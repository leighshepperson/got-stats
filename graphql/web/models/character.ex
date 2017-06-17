defmodule GOTStats.GraphQL.Models.Character do
  defstruct [
    :id,
    :url,
    :name,
    :gender,
    :culture,
    :born,
    :died,
    :titles,
    :aliases,
    :father,
    :mother,
    :spouce,
    :allegiances,
    :books,
    :pov_books,
    :tv_series,
    :played_by
  ]
end
