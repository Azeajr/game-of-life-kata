defmodule GOLTest do
  use ExUnit.Case
  doctest GOL

  test "evolve a cell" do
    assert GOL.evolve([[1, 1, 1], [1, 0, 1], [1, 1, 1]]) == [[1, 1, 1], [1, 1, 1], [1, 1, 1]]


    assert GOL.evolve([[0, 1, 0], [1, 1, 0], [0, 0, 0]]) == [[1, 1, 0], [1, 1, 0], [0, 0, 0]]

  end
end
