defmodule GOLWeb.GolController do
  use GOLWeb, :controller

  def index(conn, _params) do
    board = GOL.create_board(10, 0.5)
    render conn, "index.html", board: board
  end

  def run_game(size, percentage, iterations) do
    board = create_board(size, percentage)

    Enum.reduce(1..iterations, board, fn _iteration, board ->
      board
      |> evolve
      |> print_board
    end)

  end


  def create_board(size, percentage) do
    Enum.map(1..size, fn _ -> Enum.map(1..size, fn _ -> 0 end) end)
    |> add_random_cells((size * size * percentage) |> trunc)
  end

  def add_random_cells(board, number_of_cells) do
    if number_of_cells == 0 do
      board
    else
      board
      |> add_random_cell
      |> add_random_cells(number_of_cells - 1)
    end
  end

  def add_random_cell(board) do
    random_row = Enum.random(0..(length(Enum.at(board, 0)) - 1))
    random_column = Enum.random(0..(length(Enum.at(board, 0)) - 1))

    case Enum.at(board, random_row) |> Enum.at(random_column) do
      0 ->
        List.update_at(board, random_row, fn row ->
          List.update_at(row, random_column, fn _ -> 1 end)
        end)

      1 ->
        add_random_cell(board)
    end
  end

  def evolve(board) do
    board
    |> get_neighbors
    |> evolve_cells
  end

  def evolve_cells(board) do
    Enum.map(board, fn row ->
      Enum.map(row, fn {cell, neighbors} ->
        if (cell == 0 and neighbors >= 3) or (cell == 1 and neighbors >= 2) do
          1
        else
          0
        end
      end)
    end)
  end

  def get_neighbors(board) do
    Enum.with_index(board)
    |> Enum.map(fn {row, row_ind} ->
      Enum.with_index(row)
      |> Enum.map(fn {cell, col_ind} ->
        {cell, get_neighbors_of_cell(board, {row_ind, col_ind})}
      end)
    end)
  end

  def get_neighbors_of_cell(board, {row, column}) do
    neighbors = [
      {row - 1, column - 1},
      {row - 1, column},
      {row - 1, column + 1},
      {row, column - 1},
      {row, column + 1},
      {row + 1, column - 1},
      {row + 1, column},
      {row + 1, column + 1}
    ]

    neighbors
    |> Enum.filter(fn {row, column} ->
      row >= 0 and column >= 0 and row < length(board) and column < length(Enum.at(board, 0))
    end)
    |> Enum.map(fn {row, column} ->
      Enum.at(board, row) |> Enum.at(column)
    end)
    |> Enum.reduce(0, fn neighbor, acc ->
      acc + neighbor
    end)
  end

  def print_board(board) do
    IO.puts("")

    Enum.each(board, fn row ->
      Enum.each(row, fn cell ->
        if cell == 0 do
          IO.write("o")
        else
          IO.write("*")
        end
      end)

      IO.puts("")
    end)

    board
  end
end
