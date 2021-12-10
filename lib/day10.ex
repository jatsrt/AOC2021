defmodule AOC2021.DAY10 do
  require Logger

  def run() do
    Logger.info("AOC 2021 Day 10")

    case open_file_contents("inputs/day10.input") do
      {:ok, lines} ->
        chunks = lines |> Enum.map(&find_chunks(&1, []))
        corrupt_lines = chunks |> Enum.filter(&filter_errors/1)
        syntax_error_score = corrupt_lines |> Enum.map(&points/1) |> Enum.sum()

        Logger.info("Part One: #{syntax_error_score}")

        unclosed_lines = chunks |> Enum.filter(&(!filter_errors(&1)))

        closed_points =
          unclosed_lines
          |> Enum.map(fn {:ok, unclosed} -> close_line(unclosed, []) end)
          |> Enum.map(fn {:ok, closed} -> close_points(closed, 0) end)
          |> Enum.filter(&(&1 != 0))
          |> Enum.sort()

        middle_index = trunc(length(closed_points) / 2)
        middle_score = Enum.at(closed_points, middle_index)

        Logger.info("Part Two - #{inspect(middle_score)}")

        {:ok}

      {:error, _error} ->
        {:error}
    end
  end

  def open_file_contents(path) do
    case File.read(path) do
      {:ok, input} ->
        lines = input |> String.split("\n")
        lines = lines |> Enum.map(&String.graphemes/1)

        {:ok, lines}

      {:error, error} ->
        {:error, error}
    end
  end

  def find_chunks(["(" | t], acc), do: find_chunks(t, ["(" | acc])
  def find_chunks(["[" | t], acc), do: find_chunks(t, ["[" | acc])
  def find_chunks(["{" | t], acc), do: find_chunks(t, ["{" | acc])
  def find_chunks(["<" | t], acc), do: find_chunks(t, ["<" | acc])
  def find_chunks([")" | t], ["(" | tt]), do: find_chunks(t, tt)
  def find_chunks(["]" | t], ["[" | tt]), do: find_chunks(t, tt)
  def find_chunks(["}" | t], ["{" | tt]), do: find_chunks(t, tt)
  def find_chunks([">" | t], ["<" | tt]), do: find_chunks(t, tt)
  def find_chunks([f | _], [e | _]), do: {:error, %{expecting: closer(e), found: f}}
  def find_chunks([], acc), do: {:ok, acc}

  def closer("("), do: ")"
  def closer("["), do: "]"
  def closer("{"), do: "}"
  def closer("<"), do: ">"

  def points({:error, %{found: ")"}}), do: 3
  def points({:error, %{found: "]"}}), do: 57
  def points({:error, %{found: "}"}}), do: 1197
  def points({:error, %{found: ">"}}), do: 25137
  def points(")"), do: 1
  def points("]"), do: 2
  def points("}"), do: 3
  def points(">"), do: 4

  def filter_errors({:error, _}), do: true
  def filter_errors({:ok, _}), do: false

  def close_line([h | t], acc), do: close_line(t, acc ++ [closer(h)])
  def close_line([], acc), do: {:ok, acc}

  def close_points([h | t], acc), do: close_points(t, acc * 5 + points(h))
  def close_points([], acc), do: acc
end
