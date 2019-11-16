defmodule ConwayConsoleTest do
  use ExUnit.Case
  doctest ConwayConsole

  test "It generates a board" do
    {board, _dimensions} = ConwayConsole.generate_board(3, 3)

    assert board == %{
             {1, 1} => false,
             {1, 2} => false,
             {1, 3} => false,
             #
             {2, 1} => false,
             {2, 2} => false,
             {2, 3} => false,
             #
             {3, 1} => false,
             {3, 2} => false,
             {3, 3} => false
           }
  end

  test "it prints the board" do
    board = test_board() |> Map.put({2, 2}, true)

    printed_board = ConwayConsole.print_board({board, {3, 3}})

    assert printed_board = "      \n  x   \n      \n"
  end

  describe "&lifecycle/1" do
    test "nothing changes if there are no active cells" do
      board = test_board()

      {new_board, _dimensions} = ConwayConsole.lifecycle({board, {3, 3}})

      assert new_board == board
    end

    test "a cell dies in the next generation" do
      board = test_board() |> Map.put({2, 2}, true)
      expected_board = test_board()

      {new_board, _dimensions} = ConwayConsole.lifecycle({board, {3, 3}})

      assert new_board == expected_board
    end

    test "a live cell with two neighbors survives" do
      board = test_board() |> Map.put({2, 1}, true) |> Map.put({2, 2}, true) |> Map.put({2, 3}, true)
      assert ConwayConsole.should_live(board, {2,2})
    end

    test "a live cell with less than two neighbors dies" do
      board = test_board() |> Map.put({2, 2}, true) |> Map.put({2, 3}, true)
      refute ConwayConsole.should_live(board, {2,2})
    end

    test "a live cell with more than 3 neighbors dies" do
      board = test_board() |> Map.put({2, 1}, true) |> Map.put({2, 2}, true) |> Map.put({2, 3}, true) |> Map.put({1, 2}, true) |> Map.put({1, 3}, true)
      refute ConwayConsole.should_live(board, {2,2})
    end

    test "a dead cell with 3 neighbors revives" do
      board = test_board() |> Map.put({2, 3}, true) |> Map.put({1, 2}, true) |> Map.put({1, 3}, true)
      assert ConwayConsole.should_revive(board, {2,2})
    end
  end

  # test "It inserts live cells" do
  #   board = [
  #     [false, false, false],
  #     [false, false, false],
  #     [false, false, false]
  #   ]

  #   board = ConwayConsole.insert_cell(2, 2)

  #   assert board == [
  #     [false, false, false],
  #     [false, "x", false],
  #     [false, false, false]
  #   ]
  # end

  def test_board() do
    %{
      {1, 1} => false,
      {1, 2} => false,
      {1, 3} => false,
      #
      {2, 1} => false,
      {2, 2} => false,
      {2, 3} => false,
      #
      {3, 1} => false,
      {3, 2} => false,
      {3, 3} => false
    }
  end
end
