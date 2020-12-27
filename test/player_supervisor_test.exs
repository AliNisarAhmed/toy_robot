defmodule ToyRobot.PlayerSupervisorTest do
  use ExUnit.Case, async: true

  alias ToyRobot.Table
  alias ToyRobot.{Game.PlayerSupervisor, Game.PlayerRegistry, Robot}

  setup do
    registry_id = "player-sup-test-#{UUID.uuid4()}" |> String.to_atom()
    Registry.start_link(keys: :unique, name: registry_id)

    starting_position = %{north: 0, east: 0, facing: :north}
    player_name = "Izzy"

    {:ok, _player} = PlayerSupervisor.start_child(
      registry_id,
      build_table(),
      starting_position,
      player_name
    )

    [{_registered_player, _}] = Registry.lookup(
      registry_id, player_name
    )

    {:ok,  %{registry_id: registry_id, player_name: player_name}}
  end


  test "moves a robot forward", %{registry_id: registry_id, player_name: player_name} do

    :ok = PlayerSupervisor.move(registry_id, player_name)

    %{north: north} = PlayerSupervisor.report(registry_id, player_name)

    assert north == 1
  end

  test "reports a robot's location", %{registry_id: registry_id, player_name: player_name} do

    %{north: north} = PlayerSupervisor.report(registry_id, player_name)

    assert north == 0
  end

  def build_table do
    %Table{
      north_boundary: 4,
      east_boundary: 4
    }
  end
end
