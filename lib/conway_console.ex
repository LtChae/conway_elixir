defmodule ConwayConsole do
  @moduledoc """
  Documentation for ConwayConsole.
  """

  def print_board({board, {x, y}}) do
    top_bar = Enum.map(1..x, fn _ -> "-" end) |> Enum.join("-")

    board_string =
      Enum.reduce(1..x, "", fn x_coord, board_string ->
        new_board_string =
          Enum.reduce(1..y, board_string, fn y_coord, board_section ->
            character =
              case Map.get(board, {x_coord, y_coord}) do
                true -> "x"
                false -> " "
              end

            board_section <> " " <> character
          end)

        new_board_string <> "|\n"
      end)

    top_bar <> "-+\n" <> board_string
  end

  def log_board(board) do
    print_board(board) |> IO.puts()
    board
  end

  def generate_board(x, y, density \\ 0) do
    board =
      Enum.reduce(1..x, %{}, fn x_coord, board ->
        Enum.reduce(1..y, board, fn y_coord, board_section ->
          cell =
            case Enum.random(1..density) do
              1 when density > 0 -> true
              _ -> false
            end

          Map.put(board_section, {x_coord, y_coord}, cell)
        end)
      end)

    {board, {x, y}}
  end

  def lifecycle({old_board, {x, y}}) do
    new_board =
      Enum.reduce(1..x, %{}, fn x_coord, board ->
        Enum.reduce(1..y, board, fn y_coord, board_section ->
          new_cell =
            case Map.get(old_board, {x_coord, y_coord}) do
              true -> should_live(old_board, {x_coord, y_coord})
              false -> should_revive(old_board, {x_coord, y_coord})
            end

          Map.put(board_section, {x_coord, y_coord}, new_cell)
        end)
      end)

    {new_board, {x, y}}
  end

  def should_live(board, cell) do
    board
    |> live_neighbors(cell)
    |> case do
      0 -> false
      1 -> false
      2 -> true
      3 -> true
      _ -> false
    end
  end

  def should_revive(board, cell) do
    board
    |> live_neighbors(cell)
    |> case do
      3 -> true
      _ -> false
    end
  end

  def live_neighbors(board, {x_coord, y_coord} = cell) do
    Enum.map(-1..1, fn x ->
      Enum.map(-1..1, fn y ->
        if {x_coord - x, y_coord - y} != cell do
          Map.get(board, {x_coord - x, y_coord - y})
        else
          nil
        end
      end)
    end)
    |> List.flatten()
    |> Enum.filter(fn live -> live end)
    |> Enum.reject(fn live -> live == nil end)
    |> Enum.count()
  end

  def game_of_life(board, generations) do
    1..generations
    |> Enum.map_reduce(
      board,
      fn generation, board ->
        Process.sleep(100)
        # IO.puts("=================================")
        {generation, lifecycle(board) |> log_board()}
      end
    )

    :ok
  end
end
