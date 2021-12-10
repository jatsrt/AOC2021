defmodule AOC2021.DAY08 do
  require Logger

  defmodule Number do
    defstruct [:t, :m, :b, :tl, :tr, :bl, :br]

    # Map of values based on "lit" segments
    def value(%Number{t: 1, m: nil, b: 1, tl: 1, tr: 1, bl: 1, br: 1}), do: 0
    def value(%Number{t: nil, m: nil, b: nil, tl: nil, tr: 1, bl: nil, br: 1}), do: 1
    def value(%Number{t: 1, m: 1, b: 1, tl: nil, tr: 1, bl: 1, br: nil}), do: 2
    def value(%Number{t: 1, m: 1, b: 1, tl: nil, tr: 1, bl: nil, br: 1}), do: 3
    def value(%Number{t: nil, m: 1, b: nil, tl: 1, tr: 1, bl: nil, br: 1}), do: 4
    def value(%Number{t: 1, m: 1, b: 1, tl: 1, tr: nil, bl: nil, br: 1}), do: 5
    def value(%Number{t: 1, m: 1, b: 1, tl: 1, tr: nil, bl: 1, br: 1}), do: 6
    def value(%Number{t: 1, m: nil, b: nil, tl: nil, tr: 1, bl: nil, br: 1}), do: 7
    def value(%Number{t: 1, m: 1, b: 1, tl: 1, tr: 1, bl: 1, br: 1}), do: 8
    def value(%Number{t: 1, m: 1, b: 1, tl: 1, tr: 1, bl: nil, br: 1}), do: 9
  end

  defmodule Mapping do
    defstruct signal: nil, position: nil

    # Unique combinations of segment occurances to their positional mapping
    def new({{x, 8}, {x, 2}}), do: %Mapping{position: :top, signal: x}
    def new({{x, 7}, {x, 2}}), do: %Mapping{position: :middle, signal: x}
    def new({{x, 7}, {x, 1}}), do: %Mapping{position: :bottom, signal: x}
    def new({{x, 6}, {x, 2}}), do: %Mapping{position: :top_left, signal: x}
    def new({{x, 8}, {x, 4}}), do: %Mapping{position: :top_right, signal: x}
    def new({{x, 4}, {x, 1}}), do: %Mapping{position: :bottom_left, signal: x}
    def new({{x, 9}, {x, 4}}), do: %Mapping{position: :bottom_right, signal: x}
  end

  defmodule Encoding do
    defstruct value: nil, segments: [], number: %Number{}

    def from_string(%Encoding{segments: segments} = encoding, "a" <> t),
      do: from_string(%{encoding | segments: [:a | segments]}, t)

    def from_string(%Encoding{segments: segments} = encoding, "b" <> t),
      do: from_string(%{encoding | segments: [:b | segments]}, t)

    def from_string(%Encoding{segments: segments} = encoding, "c" <> t),
      do: from_string(%{encoding | segments: [:c | segments]}, t)

    def from_string(%Encoding{segments: segments} = encoding, "d" <> t),
      do: from_string(%{encoding | segments: [:d | segments]}, t)

    def from_string(%Encoding{segments: segments} = encoding, "e" <> t),
      do: from_string(%{encoding | segments: [:e | segments]}, t)

    def from_string(%Encoding{segments: segments} = encoding, "f" <> t),
      do: from_string(%{encoding | segments: [:f | segments]}, t)

    def from_string(%Encoding{segments: segments} = encoding, "g" <> t),
      do: from_string(%{encoding | segments: [:g | segments]}, t)

    def from_string(%Encoding{} = encoding, ""), do: encode_known_value(encoding)

    defp encode_known_value(%Encoding{segments: s} = encoding) when length(s) == 2,
      do: %{encoding | value: 1}

    defp encode_known_value(%Encoding{segments: s} = encoding) when length(s) == 4,
      do: %{encoding | value: 4}

    defp encode_known_value(%Encoding{segments: s} = encoding) when length(s) == 3,
      do: %{encoding | value: 7}

    defp encode_known_value(%Encoding{segments: s} = encoding) when length(s) == 7,
      do: %{encoding | value: 8}

    defp encode_known_value(encoding), do: encoding

    def activate(%Encoding{segments: segments, number: number} = encoding, mappings) do
      number = activate_segments(segments, number, mappings)
      %{encoding | number: number}
    end

    defp activate_segments([segment | segments], %Number{} = number, mappings) do
      number = activate_segment(segment, number, mappings)
      activate_segments(segments, number, mappings)
    end

    defp activate_segments([], %Number{} = number, _), do: number

    defp activate_segment(segment, %Number{} = number, [
           %Mapping{signal: segment, position: position} | mappings
         ]) do
      case position do
        :top -> activate_segment(segment, %{number | t: 1}, mappings)
        :middle -> activate_segment(segment, %{number | m: 1}, mappings)
        :bottom -> activate_segment(segment, %{number | b: 1}, mappings)
        :top_right -> activate_segment(segment, %{number | tr: 1}, mappings)
        :top_left -> activate_segment(segment, %{number | tl: 1}, mappings)
        :bottom_right -> activate_segment(segment, %{number | br: 1}, mappings)
        :bottom_left -> activate_segment(segment, %{number | bl: 1}, mappings)
      end
    end

    defp activate_segment(segment, %Number{} = number, [_ | mappings]),
      do: activate_segment(segment, number, mappings)

    defp activate_segment(_, %Number{} = number, []), do: number
  end

  defmodule Output do
    defstruct signals: [], segments: [], mappings: []
  end

  def run() do
    Logger.info("AOC 2021 Day 8")

    case open_file_contents("inputs/day08.input") do
      {:ok, outputs} ->
        segments = outputs |> Enum.map(&Map.get(&1, :segments))

        # Simple brute force answer
        appearances =
          segments
          |> Enum.map(fn segment ->
            segment
            |> Enum.filter(fn segment ->
              len = length(segment.segments)
              len == 2 || len == 4 || len == 3 || len == 7
            end)
          end)
          |> Enum.map(&length/1)
          |> Enum.sum()

        Logger.info("Part One - Apperances: #{appearances}")

        {:ok, output_numbers} = find_output_number(outputs)
        Logger.info("Part 2 - Count #{output_numbers |> Enum.sum()}")

        {:ok}

      {:error, _error} ->
        {:error}
    end
  end

  defp open_file_contents(path) do
    case File.read(path) do
      {:ok, input} ->
        outputs_raw =
          input |> String.trim() |> String.split("\n") |> Enum.map(&String.split(&1, "|"))

        outputs =
          outputs_raw
          |> Enum.map(fn [signals, segments] ->
            %Output{
              signals:
                signals
                |> String.trim()
                |> String.split(" ")
                |> Enum.map(&(%Encoding{} |> Encoding.from_string(&1))),
              segments:
                segments
                |> String.trim()
                |> String.split(" ")
                |> Enum.map(&(%Encoding{} |> Encoding.from_string(&1)))
            }
          end)

        {:ok, outputs}

      {:error, error} ->
        {:error, error}
    end
  end

  defp find_output_number(output, acc \\ [])

  defp find_output_number([%Output{segments: segments, signals: signals} | t], acc) do
    # Do what is easy and identify 1, 4, 7, 8
    known_signals = signals |> Enum.filter(&(!is_nil(&1.value)))

    # The above two pieces of information give a unique comination for each possible segment mapping
    mappings =
      Enum.zip(
        # How frequent do segments show up
        signals |> Enum.map(& &1.segments) |> List.flatten() |> Enum.frequencies(),
        # # How frequent do known segments show up
        known_signals |> Enum.map(& &1.segments) |> List.flatten() |> Enum.frequencies()
      )
      |> Enum.map(&Mapping.new/1)

    # Take the number values and turn them into a single number
    output_number =
      segments
      |> Enum.map(&Encoding.activate(&1, mappings))
      |> Enum.map(&Number.value(&1.number))
      |> Enum.join("")
      |> String.to_integer()

    find_output_number(t, [output_number | acc])
  end

  defp find_output_number([], acc), do: {:ok, acc}

  # 1
end
