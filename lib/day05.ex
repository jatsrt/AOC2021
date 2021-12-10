defmodule AOC2021.DAY05 do
  require Logger

  def run() do
    Logger.info("AOC 2021 Day 5")

    case open_file_contents("inputs/day05.input") do
      {:ok, contents} ->
        base_matrix =
          0..999
          |> Enum.map(fn row ->
            {row, 0..999 |> Enum.map(fn col -> {col, 0} end) |> Map.new()}
          end)
          |> Map.new()

        {:ok, overlap_count} =
          fill_matrix(contents, base_matrix, false)
          |> Enum.map(fn {_, v} -> v |> Enum.map(fn {_, v} -> v end) end)
          |> count_overlap()

        Logger.info("Part One - Overlap Count #{overlap_count}")

        {:ok, overlap_count} =
          fill_matrix(contents, base_matrix, true)
          |> Enum.map(fn {_, v} -> v |> Enum.map(fn {_, v} -> v end) end)
          |> count_overlap()

        Logger.info("Part Two - Overlap Count #{overlap_count}")

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
         |> Enum.map(&String.replace(&1, " -> ", ","))
         |> Enum.map(&String.split(&1, ","))
         |> Enum.map(fn row -> row |> Enum.map(&String.to_integer/1) end)}

      {:error, error} ->
        {:error, error}
    end
  end

  defp fill_matrix([[x1, y1, x2, y2] | t], matrix, diagonal) do
    matrix = follow_line(Enum.to_list(x1..x2), Enum.to_list(y1..y2), matrix, diagonal)
    fill_matrix(t, matrix, diagonal)
  end

  defp fill_matrix([], base_mtrix, _), do: base_mtrix

  @spec follow_line(nonempty_maybe_improper_list, nonempty_maybe_improper_list, any, false) :: any
  defp follow_line([x | t], [y], matrix, diagonal),
    do: follow_line(t, [y], put_in(matrix[x][y], matrix[x][y] + 1), diagonal)

  defp follow_line([x], [y | t], matrix, diagonal),
    do: follow_line([x], t, put_in(matrix[x][y], matrix[x][y] + 1), diagonal)

  defp follow_line([x | xt], [y | yt], matrix, true),
    do: follow_line(xt, yt, put_in(matrix[x][y], matrix[x][y] + 1), true)

  defp follow_line([_ | _], [_ | _], matrix, false), do: matrix
  defp follow_line([x], [y], matrix, _), do: put_in(matrix[x][y], matrix[x][y] + 1)
  defp follow_line([], [_], matrix, _), do: matrix
  defp follow_line([_], [], matrix, _), do: matrix

  defp count_overlap(list, acc \\ 0)

  defp count_overlap([h | t], acc),
    do: count_overlap(t, acc + (h |> Enum.map(&count_point/1) |> Enum.sum()))

  defp count_overlap([], acc), do: {:ok, acc}

  defp count_point(p) when p > 1, do: 1
  defp count_point(_), do: 0
end
