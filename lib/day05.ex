defmodule AOC2021.DAY05 do
  def run() do
    IO.puts("AOC 2021 Day 5")

    contents =
      "inputs/day05.input"
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(&String.replace(&1, " -> ", ","))
      |> Enum.map(&String.split(&1, ","))
      |> Enum.map(fn row -> row |> Enum.map(&String.to_integer/1) end)

    base_matrix = Enum.map(0..999, fn row -> {row, Enum.map(0..999, fn col -> {col, 0} end) |> Map.new()} end) |> Map.new()

    overlap_count =
      Enum.reduce(contents, base_matrix, fn [x1, y1, x2, y2], matrix -> follow_line(Enum.to_list(x1..x2), Enum.to_list(y1..y2), matrix, false) end)
      |> Enum.map(fn x -> elem(x, 1) |> Enum.map(&elem(&1, 1)) end)
      |> Enum.reduce(0, fn v, sum -> Enum.reduce(v, 0, &if(&1 > 1, do: &2 + 1, else: &2)) + sum end)

    IO.puts("Part One - Overlap Count #{overlap_count}")

    overlap_count =
      Enum.reduce(contents, base_matrix, fn [x1, y1, x2, y2], matrix -> follow_line(Enum.to_list(x1..x2), Enum.to_list(y1..y2), matrix, true) end)
      |> Enum.map(fn x -> elem(x, 1) |> Enum.map(&elem(&1, 1)) end)
      |> Enum.reduce(0, fn v, sum -> Enum.reduce(v, 0, &if(&1 > 1, do: &2 + 1, else: &2)) + sum end)

    IO.puts("Part Two - Overlap Count #{overlap_count}")
  end

  defp follow_line([x | t], [y], matrix, diagonal), do: follow_line(t, [y], put_in(matrix[x][y], matrix[x][y] + 1), diagonal)
  defp follow_line([x], [y | t], matrix, diagonal), do: follow_line([x], t, put_in(matrix[x][y], matrix[x][y] + 1), diagonal)
  defp follow_line([x | xt], [y | yt], matrix, true), do: follow_line(xt, yt, put_in(matrix[x][y], matrix[x][y] + 1), true)
  defp follow_line([x], [y], matrix, _), do: put_in(matrix[x][y], matrix[x][y] + 1)
  defp follow_line([_ | _], [_ | _], matrix, false), do: matrix
  defp follow_line([], [_], matrix, _), do: matrix
  defp follow_line([_], [], matrix, _), do: matrix
end
