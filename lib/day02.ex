defmodule AOC2021.DAY02 do
  require Logger

  def run() do
    Logger.info("AOC 2021 Day 2")

    case open_file_contents("inputs/day02.input") do
      {:ok, contents} ->
        {:ok, depth, hp} = calculate(contents)
        Logger.info("Part One - Depth:#{depth} HP:#{hp} Result:#{hp * depth}")

        {:ok, depth, hp, aim} = calculate_with_aim(contents)
        Logger.info("Part Two - Aim:#{aim} Depth:#{depth} HP:#{hp} Resut:#{hp * depth}")

        {:ok}

      {:error, _error} ->
        {:error}
    end
  end

  defp open_file_contents(path) do
    case File.read(path) do
      {:ok, input} ->
        {:ok,
         input
         |> String.split("\n", trim: true)
         |> Enum.map(&String.split/1)
         |> Enum.map(fn [a, v] -> [a |> String.to_atom(), v |> String.to_integer()] end)}

      {:error, error} ->
        {:error, error}
    end
  end

  defp calculate(list, depth \\ 0, hp \\ 0)
  defp calculate([[:up, a] | t], depth, hp), do: calculate(t, depth - a, hp)
  defp calculate([[:down, a] | t], depth, hp), do: calculate(t, depth + a, hp)
  defp calculate([[:forward, a] | t], depth, hp), do: calculate(t, depth, hp + a)
  defp calculate([], depth, hp), do: {:ok, depth, hp}

  defp calculate_with_aim(list, depth \\ 0, hp \\ 0, aim \\ 0)

  defp calculate_with_aim([[:up, a] | t], depth, hp, aim),
    do: calculate_with_aim(t, depth, hp, aim - a)

  defp calculate_with_aim([[:down, a] | t], depth, hp, aim),
    do: calculate_with_aim(t, depth, hp, aim + a)

  defp calculate_with_aim([[:forward, a] | t], depth, hp, aim),
    do: calculate_with_aim(t, depth + aim * a, hp + a, aim)

  defp calculate_with_aim([], depth, hp, aim), do: {:ok, depth, hp, aim}
end
