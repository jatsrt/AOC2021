defmodule AOC2021.DAY06 do
  require Logger

  defmodule Fishes do
    defstruct zero: 0, one: 0, two: 0, three: 0, four: 0, five: 0, six: 0, seven: 0, eight: 0

    def new(fish_map) when is_map(fish_map) do
      %Fishes{
        zero: Map.get(fish_map, 0, 0),
        one: Map.get(fish_map, 1, 0),
        two: Map.get(fish_map, 2, 0),
        three: Map.get(fish_map, 3, 0),
        four: Map.get(fish_map, 4, 0),
        five: Map.get(fish_map, 5, 0),
        six: Map.get(fish_map, 6, 0),
        seven: Map.get(fish_map, 7, 0),
        eight: Map.get(fish_map, 8, 0)
      }
    end

    def sum(%Fishes{} = fishes) do
      fishes.zero + fishes.one + fishes.two + fishes.three + fishes.four + fishes.five +
        fishes.six + fishes.seven + fishes.eight
    end

    def breed(%Fishes{} = fishes) do
      %Fishes{
        zero: fishes.one,
        one: fishes.two,
        two: fishes.three,
        three: fishes.four,
        four: fishes.five,
        five: fishes.six,
        six: fishes.zero + fishes.seven,
        seven: fishes.eight,
        eight: fishes.zero
      }
    end

    def breed_days(%Fishes{} = fishes, day, days) when day < days,
      do: breed_days(Fishes.breed(fishes), day + 1, days)

    def breed_days(%Fishes{} = fishes, _, _), do: {:ok, fishes}
  end

  def run() do
    Logger.info("AOC 2021 Day 6")

    case open_file_contents("inputs/day06.input") do
      {:ok, contents} ->
        fish_map = contents |> Enum.frequencies()
        fishes_base = Fishes.new(fish_map)

        {:ok, fishes} = Fishes.breed_days(fishes_base, 0, 80)
        Logger.info("Part 1 - Fish Count: #{Fishes.sum(fishes)}")

        {:ok, fishes} = Fishes.breed_days(fishes_base, 0, 256)
        Logger.info("Part 2 - Fish Count: #{Fishes.sum(fishes)}")

        {:ok}

      {:error, _error} ->
        {:error}
    end
  end

  defp open_file_contents(path) do
    case File.read(path) do
      {:ok, input} ->
        {:ok, input |> String.split(",") |> Enum.map(&String.to_integer/1)}

      {:error, error} ->
        {:error, error}
    end
  end
end
