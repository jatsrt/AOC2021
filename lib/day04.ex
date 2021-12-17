defmodule AOC2021.DAY04 do
  def run() do
    IO.puts("AOC 2021 Day 4")

    contents = "inputs/day04.input" |> File.read!() |> String.split("\n", trim: true)

    [balls, cards] = generate_bingo_game(contents, false)
    {:ok, ball, card} = play_winning_bingo(cards, balls)
    card_sum = calculate_sum(card)
    IO.puts("Part One - Ball: #{ball} Card Sum: #{card_sum} Answer: #{card_sum * ball}")

    {:ok, ball, card} = play_losing_bingo(cards, balls)
    card_sum = calculate_sum(card)
    IO.puts("Part Two - Ball: #{ball} Card Sum: #{card_sum} Answer: #{card_sum * ball}")
  end

  defp generate_bingo_game(contents, default) do
    [all_balls | all_cards] = contents
    balls = all_balls |> String.split(",") |> Enum.map(&String.to_integer/1)

    cards =
      all_cards
      |> Enum.chunk_every(5)
      |> Enum.map(fn card ->
        card
        |> Enum.map(fn row ->
          row
          |> String.split()
          |> Enum.map(&String.to_integer/1)
          |> Enum.map(fn i -> {i, default} end)
        end)
      end)

    [balls, cards]
  end

  defp play_winning_bingo(cards, [ball | balls]) do
    cards = Enum.map(cards, fn card -> card |> Enum.map(&daub(&1, ball, [])) end)

    case find_winning_card(cards) do
      {:ok, card} -> {:ok, ball, card}
      {:skip} -> play_winning_bingo(cards, balls)
    end
  end

  defp play_winning_bingo(_, []), do: {:ok}

  defp play_losing_bingo(cards, [ball | balls]) do
    cards = Enum.map(cards, fn card -> card |> Enum.map(&daub(&1, ball)) end)

    case filter_winning_cards(cards) do
      [] ->
        [card] = cards
        {:ok, ball, card}

      cards ->
        play_losing_bingo(cards, balls)
    end
  end

  defp play_losing_bingo(_, []), do: {:none}

  defp find_winning_card([card | cards]) do
    case find_winning_row_column(card) do
      {:ok} ->
        {:ok, card}

      {:skip} ->
        case find_winning_row_column(card |> List.zip() |> Enum.map(&Tuple.to_list/1)) do
          {:ok} -> {:ok, card}
          {:skip} -> find_winning_card(cards)
        end
    end
  end

  defp find_winning_card([]), do: {:skip}

  defp find_winning_row_column([row | rows]) do
    case row |> Enum.reduce(true, fn {_, b}, acc -> b && acc end) do
      false -> find_winning_row_column(rows)
      true -> {:ok}
    end
  end

  defp find_winning_row_column([]), do: {:skip}

  defp filter_winning_cards(list, acc \\ [])

  defp filter_winning_cards([card | cards], acc) do
    case find_winning_card([card]) do
      {:ok, _card} -> filter_winning_cards(cards, acc)
      {:skip} -> filter_winning_cards(cards, [card] ++ acc)
    end
  end

  defp filter_winning_cards([], acc), do: acc

  defp calculate_sum(list, acc \\ 0)
  defp calculate_sum([row | rows], acc), do: calculate_sum(rows, Enum.reduce(row, 0, &reduce_val/2) + acc)
  defp calculate_sum([], acc), do: acc

  defp reduce_val({_, true}, acc), do: acc
  defp reduce_val({v, false}, acc), do: v + acc

  defp daub(list, ball, acc \\ [])
  defp daub([{n, b} | t], ball, acc), do: daub(t, ball, [{n, b || n == ball}] ++ acc)
  defp daub([], _, acc), do: acc
end
