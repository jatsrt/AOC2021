defmodule AOC2021.DAY05 do
  require Logger

  def run() do
    Logger.info("AOC 2021 Day 5")

    case open_file_contents("inputs/day05.input") do
      {:ok, contents} ->
        base_matrix = generate_matrix(0, 1000, [])

        {:ok, matrix} = contents |> fill_matrix(base_matrix, false)
        {:ok, count} = matrix |> count_overlap(0)
        Logger.info("Part One - Count #{count}")

        {:ok, matrix} = contents |> fill_matrix(base_matrix, true)
        {:ok, count} = matrix |> count_overlap(0)
        Logger.info("Part Two - Count #{count}")

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

  def generate_matrix(count, size, acc) when count < size,
    do: generate_matrix(count + 1, size, [List.duplicate(0, size) | acc])

  def generate_matrix(_, _, acc), do: acc

  def fill_matrix([h | t], matrix, diagonal),
    do: fill_matrix(t, fill_matrix_point(h, matrix, diagonal), diagonal)

  def fill_matrix([], matrix, _), do: {:ok, matrix}

  # Right
  def fill_matrix_point([x1, y1, x2, y2], matrix, diagonal) when x1 < x2 and y1 == y2 do
    matrix = List.update_at(matrix, y1, fn row -> List.update_at(row, x1, &(&1 + 1)) end)
    fill_matrix_point([x1 + 1, y1, x2, y2], matrix, diagonal)
  end

  # Left
  def fill_matrix_point([x1, y1, x2, y2], matrix, diagonal) when x1 > x2 and y1 == y2 do
    matrix = List.update_at(matrix, y1, fn row -> List.update_at(row, x1, &(&1 + 1)) end)
    fill_matrix_point([x1 - 1, y1, x2, y2], matrix, diagonal)
  end

  # Up
  def fill_matrix_point([x1, y1, x2, y2], matrix, diagonal) when x1 == x2 and y1 < y2 do
    matrix = List.update_at(matrix, y1, fn row -> List.update_at(row, x1, &(&1 + 1)) end)
    fill_matrix_point([x1, y1 + 1, x2, y2], matrix, diagonal)
  end

  # Down
  def fill_matrix_point([x1, y1, x2, y2], matrix, diagonal) when x1 == x2 and y1 > y2 do
    matrix = List.update_at(matrix, y1, fn row -> List.update_at(row, x1, &(&1 + 1)) end)
    fill_matrix_point([x1, y1 - 1, x2, y2], matrix, diagonal)
  end

  # Diagonal Up Right
  def fill_matrix_point([x1, y1, x2, y2], matrix, diagonal)
      when diagonal and x1 < x2 and y1 < y2 do
    matrix = List.update_at(matrix, y1, fn row -> List.update_at(row, x1, &(&1 + 1)) end)
    fill_matrix_point([x1 + 1, y1 + 1, x2, y2], matrix, diagonal)
  end

  # Diagonal Up Left
  def fill_matrix_point([x1, y1, x2, y2], matrix, diagonal)
      when diagonal and x1 > x2 and y1 < y2 do
    matrix = List.update_at(matrix, y1, fn row -> List.update_at(row, x1, &(&1 + 1)) end)
    fill_matrix_point([x1 - 1, y1 + 1, x2, y2], matrix, diagonal)
  end

  # Diagonal Down Right
  def fill_matrix_point([x1, y1, x2, y2], matrix, diagonal)
      when diagonal and x1 < x2 and y1 > y2 do
    matrix = List.update_at(matrix, y1, fn row -> List.update_at(row, x1, &(&1 + 1)) end)
    fill_matrix_point([x1 + 1, y1 - 1, x2, y2], matrix, diagonal)
  end

  # Diagonal Down Left
  def fill_matrix_point([x1, y1, x2, y2], matrix, diagonal)
      when diagonal and x1 > x2 and y1 > y2 do
    matrix = List.update_at(matrix, y1, fn row -> List.update_at(row, x1, &(&1 + 1)) end)
    fill_matrix_point([x1 - 1, y1 - 1, x2, y2], matrix, diagonal)
  end

  # End Point
  def fill_matrix_point([x1, y1, x2, y2], matrix, _) when x1 == x2 and y1 == y2 do
    List.update_at(matrix, y1, fn row -> List.update_at(row, x1, &(&1 + 1)) end)
  end

  def fill_matrix_point(_, matrix, _), do: matrix

  def count_overlap([h | t], acc) do
    count_overlap(t, acc + (h |> Enum.map(&count_point/1) |> Enum.sum()))
  end

  def count_overlap([], acc), do: {:ok, acc}

  def count_point(p) when p > 1, do: 1
  def count_point(_), do: 0
end
