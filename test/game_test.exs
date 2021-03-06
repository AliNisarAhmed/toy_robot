defmodule ToyRobot.GameTest do
  use ExUnit.Case, async: true

  alias ToyRobot.Game

  setup do
    {:ok, game} = Game.start(north_boundary: 4, east_boundary: 4)
    {:ok, %{game: game}}
  end

  test "can place a player", %{game: game} do
    :ok = Game.place(game, %{north: 0, east: 0, facing: :north}, "Rosie")
    assert Game.player_count(game) == 1
  end

  test "cannot place a robot outside the bounds of the game", %{game: game} do
    assert Game.place(
             game,
             %{north: 10, east: 10, facing: :north},
             "Eve"
           ) == {:error, :out_of_bounds}
  end

  test "cannot place a robot in the same space as another robot", %{game: game} do
    starting_position = %{north: 0, east: 0, facing: :north}

    :ok = Game.place(game, starting_position, "Wall-E")

    assert Game.place(game, starting_position, "Eva") == {:error, :occupied}
  end

  describe "move" do
    test "cannot move a robot onto another robot's square", %{game: game} do
      :ok = Game.place(game, %{north: 0, east: 0, facing: :north}, "Marvin")
      :ok = Game.place(game, %{north: 1, east: 0, facing: :south}, "Chappie")

      assert Game.move(game, "Chappie") == {:error, :occupied}

    end

    test "can move onto an unoccupied square", %{game: game} do
      :ok = Game.place(
        game,
        %{north: 0, east: 0, facing: :east},
        "Mr Roboto"
      )

      :ok = Game.place(
        game,
        %{north: 1, east: 1, facing: :south},
        "Kit"
      )

      assert Game.move(game, "Mr Roboto") == :ok
    end
  end

  describe "respawning" do
    test "davros does not respawn on (1,1)", %{game: game} do
      davros = "Davros"
      izzy = "Izzy"

      izzy_origin = %{east: 1, north: 0, facing: :north}
      :ok = Game.place(game, izzy_origin, izzy)

      davros_origin = %{east: 1, north: 1, facing: :west}
      :ok = Game.place(game, davros_origin, davros)
      :ok = Game.move(game, davros)
      :ok = Game.move(game, izzy)
      :ok = Game.move(game, davros)

      :timer.sleep(100)

      refute match?(%{north: 1, east: 1}, Game.report(game, davros))

    end
  end

end
