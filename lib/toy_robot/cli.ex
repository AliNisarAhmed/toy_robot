defmodule ToyRobot.CLI do
  def main([file_name]) do
    if File.exists?(file_name) do
      File.stream!(file_name)
      |> Enum.map(&String.trim/1)
      |> ToyRobot.CommandInterpreter.interpret()
      |> ToyRobot.CommandRunner.run()
    else
      IO.puts("The file #{file_name} does not exist")
    end
  end


  def main([]) do
    IO.puts "Usage: toy_robot commands.txt (On Windows, do escript toy_robot commands.txt)"
  end

  def main(_list), do: IO.puts("Usage: toy_robot commands.txt (On Windows, do escript toy_robot commands.txt)")
end

## Generate the exe file: mix escript.build
## Run the exe file like this: escript toy_robot commands.txt
