defmodule AOC2021.DAY05 do
  require Logger

  def run() do
    Logger.info("AOC 2021 Day 5")

    case open_file_contents("inputs/day05.input") do
      {:ok, contents} ->
        base_matrix =
          0..999
          |> Enum.map(fn row -> {row, 0..999 |> Enum.map(fn col -> {col, 0} end) |> Map.new()} end)
          |> Map.new()

        filled_matrix = fill_matrix(contents, base_matrix, false)

        {:ok, overlap_count} =
          filled_matrix
          |> Enum.map(fn {_, v} -> v |> Enum.map(fn {_, v} -> v end) end)
          |> count_overlap(0)

        Logger.info("Part One - Overlap Count #{overlap_count}")

        filled_matrix = fill_matrix(contents, base_matrix, true)

        {:ok, overlap_count} =
          filled_matrix
          |> Enum.map(fn {_, v} -> v |> Enum.map(fn {_, v} -> v end) end)
          |> count_overlap(0)

        Logger.info("Part Two - Overlap Count #{overlap_count}")

        {:ok}

      {:error, _error} ->
        {:error}
    end
  end

  def open_file_contents(path) do
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

  def fill_matrix([[x1, y1, x2, y2] | t], matrix, diagonal) do
    fill_matrix(
      t,
      follow_line(x1..x2 |> Enum.to_list(), y1..y2 |> Enum.to_list(), matrix, diagonal),
      diagonal
    )
  end

  def fill_matrix([], base_mtrix, _), do: base_mtrix

  def follow_line([x], [y], matrix, _) do
    put_in(matrix[x][y], matrix[x][y] + 1)
    # matrix
  end

  def follow_line([x | t], [y], matrix, diagonal) do
    follow_line(t, [y], put_in(matrix[x][y], matrix[x][y] + 1), diagonal)
  end

  def follow_line([x], [y | t], matrix, diagonal) do
    follow_line([x], t, put_in(matrix[x][y], matrix[x][y] + 1), diagonal)
  end

  def follow_line([x | xt], [y | yt], matrix, diagonal) do
    case diagonal do
      true -> follow_line(xt, yt, put_in(matrix[x][y], matrix[x][y] + 1), diagonal)
      false -> matrix
    end
  end

  def count_overlap([h | t], acc) do
    count_overlap(t, acc + (h |> Enum.map(&count_point/1) |> Enum.sum()))
  end

  def count_overlap([], acc), do: {:ok, acc}

  def count_point(p) when p > 1, do: 1
  def count_point(_), do: 0
end
