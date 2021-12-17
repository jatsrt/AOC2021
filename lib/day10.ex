defmodule AOC2021.DAY10 do
  def run() do
    IO.puts("AOC 2021 Day 10")
    lines = "inputs/day10.input" |> File.read!() |> String.split("\n") |> Enum.map(&String.graphemes/1)

    chunks = lines |> Enum.map(&find_chunks(&1))
    corrupt_lines = chunks |> Enum.filter(&filter_errors/1)
    syntax_error_score = corrupt_lines |> Enum.map(&points/1) |> Enum.sum()
    IO.puts("Part One: #{syntax_error_score}")

    unclosed_lines = chunks |> Enum.filter(&(!filter_errors(&1)))

    closed_points =
      unclosed_lines
      |> Enum.map(fn {:ok, unclosed} -> close_line(unclosed) end)
      |> Enum.map(fn {:ok, closed} -> close_points(closed) end)
      |> Enum.filter(&(&1 != 0))
      |> Enum.sort()

    middle_index = trunc(length(closed_points) / 2)
    middle_score = Enum.at(closed_points, middle_index)
    IO.puts("Part Two - #{inspect(middle_score)}")
  end

  defp find_chunks(list, acc \\ [])
  defp find_chunks(["(" | t], acc), do: find_chunks(t, ["(" | acc])
  defp find_chunks(["[" | t], acc), do: find_chunks(t, ["[" | acc])
  defp find_chunks(["{" | t], acc), do: find_chunks(t, ["{" | acc])
  defp find_chunks(["<" | t], acc), do: find_chunks(t, ["<" | acc])
  defp find_chunks([")" | t], ["(" | tt]), do: find_chunks(t, tt)
  defp find_chunks(["]" | t], ["[" | tt]), do: find_chunks(t, tt)
  defp find_chunks(["}" | t], ["{" | tt]), do: find_chunks(t, tt)
  defp find_chunks([">" | t], ["<" | tt]), do: find_chunks(t, tt)
  defp find_chunks([f | _], [e | _]), do: {:error, %{expecting: closer(e), found: f}}
  defp find_chunks([], acc), do: {:ok, acc}

  defp closer("("), do: ")"
  defp closer("["), do: "]"
  defp closer("{"), do: "}"
  defp closer("<"), do: ">"

  defp points({:error, %{found: ")"}}), do: 3
  defp points({:error, %{found: "]"}}), do: 57
  defp points({:error, %{found: "}"}}), do: 1197
  defp points({:error, %{found: ">"}}), do: 25137
  defp points(")"), do: 1
  defp points("]"), do: 2
  defp points("}"), do: 3
  defp points(">"), do: 4

  defp filter_errors({:error, _}), do: true
  defp filter_errors({:ok, _}), do: false

  defp close_line(list, acc \\ [])
  defp close_line([h | t], acc), do: close_line(t, acc ++ [closer(h)])
  defp close_line([], acc), do: {:ok, acc}

  defp close_points(list, acc \\ 0)
  defp close_points([h | t], acc), do: close_points(t, acc * 5 + points(h))
  defp close_points([], acc), do: acc
end
