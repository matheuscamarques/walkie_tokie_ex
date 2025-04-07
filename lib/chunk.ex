defmodule Chunk do
  @type id :: binary()
  @type index :: non_neg_integer()
  @type total :: non_neg_integer()
  @type data :: binary()

  @type t :: {:chunk, id, index, total, data}

  @spec new() :: t
  def new(), do: {:chunk, <<>>, 0, 0, <<>>}
end
