defmodule AOC2021.DAY13 do
  def run() do
    IO.puts("AOC 2021 Day 13")
    [points, folds] = "inputs/day13.input" |> File.read!() |> String.split("\n\n", trim: true)

    folds =
      folds
      |> String.split("\n", trim: true)
      |> Enum.map(&String.replace(&1, "fold along ", ""))
      |> Enum.map(&(&1 |> String.split("=")))
      |> Enum.map(fn [direction, position] -> {direction, String.to_integer(position)} end)

    points =
      points
      |> String.split("\n", trim: true)
      |> Enum.map(fn point -> String.split(point, ",", trim: true) |> Enum.map(&String.to_integer/1) |> List.to_tuple() end)

    folded_points = fold_paper(points, folds |> Enum.take(1))
    IO.puts("Part One - #{folded_points |> MapSet.size()}")

    folded_points = fold_paper(points, folds)
    IO.puts("Part Two - #{folded_points |> MapSet.size()}")

    {x_s, y_s} = folded_points |> Enum.unzip()
    x_max = Enum.max(x_s)
    y_max = Enum.max(y_s)

    Enum.map_join(0..y_max, "\n", fn y -> Enum.map_join(0..x_max, "", fn x -> char_for(x, y, folded_points) end) end) |> IO.puts()
  end

  defp fold_paper(points, folds), do: folds |> Enum.reduce(points, fn {direction, position}, points -> points |> Enum.map(&fold(direction, position, &1)) |> MapSet.new() end)

  def fold("x", position, {x, y} = point), do: if(x > position, do: {position - (x - position), y}, else: point)
  def fold("y", position, {x, y} = point), do: if(y > position, do: {x, position - (y - position)}, else: point)

  def char_for(x, y, points), do: if(MapSet.member?(points, {x, y}), do: "##", else: "..")
end
