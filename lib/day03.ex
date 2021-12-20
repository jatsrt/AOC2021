defmodule AOC2021.DAY03 do
  def run() do
    IO.puts("AOC 2021 Day 3")

    bin_nums =
      "inputs/day03.input"
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(fn s -> s |> String.split("", trim: true) |> Enum.map(&String.to_integer/1) end)

    frequencies = bin_nums |> Enum.zip_with(&Enum.frequencies/1)
    gamma = frequencies |> Enum.map(fn freqs -> if freqs[0] > freqs[1], do: "0", else: "1" end) |> Enum.join() |> String.to_integer(2)
    epsilon = frequencies |> Enum.map(fn freqs -> if freqs[0] < freqs[1], do: "0", else: "1" end) |> Enum.join() |> String.to_integer(2)
    IO.puts("Part One - Gamma:#{gamma} Epsilon:#{epsilon} Product:#{gamma * epsilon}")

    o2 = process_list(bin_nums, :o2)
    co2 = process_list(bin_nums, :co2)
    IO.puts("Part Two - Oxygen:#{o2} CO2:#{co2} Product:#{o2 * co2}")
  end

  defp process_list(list, sensor_type, count \\ 0)
  defp process_list([bin_num], _, _), do: bin_num |> Enum.join() |> String.to_integer(2)

  defp process_list(bin_nums, sensor_type, i) do
    common_bit = bin_nums |> Enum.map(&Enum.at(&1, i)) |> Enum.frequencies() |> find_common(sensor_type)
    found = bin_nums |> Enum.filter(&(Enum.at(&1, i) == common_bit))
    process_list(found, sensor_type, i + 1)
  end

  defp find_common(freqs, _) when map_size(freqs) == 1, do: freqs |> Map.keys() |> List.first()
  defp find_common(freqs, :o2), do: if(freqs[0] <= freqs[1], do: 0, else: 1)
  defp find_common(freqs, :co2), do: if(freqs[0] <= freqs[1], do: 1, else: 0)
end
