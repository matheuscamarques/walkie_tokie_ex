defmodule WalkieTokieTest do
  use ExUnit.Case
  doctest WalkieTokie

  test "greets the world" do
    assert WalkieTokie.hello() == :world
  end
end
