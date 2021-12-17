defmodule AOC2021.DAY14 do
  def run() do
    IO.puts("AOC 2021 Day 14 - Intro to streaming and reducing")
    [input, rules] = "inputs/day14.input" |> File.read!() |> String.split("\n\n", trim: true)

    rules =
      rules
      |> String.split("\n", trim: true)
      |> Enum.map(fn line -> line |> String.split(" -> ", trim: true) end)
      |> Enum.map(fn [l, r] -> {String.split(l, "", trim: true), r} end)
      |> Map.new()

    frequencies =
      input
      |> String.codepoints()
      |> Enum.chunk_every(2, 1)
      |> Enum.frequencies()

    {{_min_char, min}, {_max_char, max}} =
      frequencies
      |> Stream.iterate(&process_pairs(&1, rules))
      |> Enum.at(10)
      |> Enum.reduce(%{}, fn {pair, count}, counts -> Map.update(counts, pair |> List.first(), count, &(&1 + count)) end)
      |> Enum.min_max_by(fn {_, count} -> count end)

    IO.puts("Part One - #{max - min}")

    {{_min_char, min}, {_max_char, max}} =
      frequencies
      |> Stream.iterate(&process_pairs(&1, rules))
      |> Enum.at(40)
      |> Enum.reduce(%{}, fn {pair, count}, acc -> Map.update(acc, pair |> List.first(), count, &(&1 + count)) end)
      |> Enum.min_max_by(fn {_, count} -> count end)

    IO.puts("Part Two - #{max - min}")
  end

  defp process_pairs(frequencies, rules),
    do: frequencies |> Enum.map(&apply_rule(&1, rules)) |> List.flatten() |> Enum.reduce(%{}, fn {pair, count}, acc -> Map.update(acc, pair, count, &(&1 + count)) end)

  defp apply_rule({[l, r] = pair, count}, rules), do: [{[l, rules[pair]], count}, {[rules[pair], r], count}]
  defp apply_rule(other, _), do: other
end
