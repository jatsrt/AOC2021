defmodule AOC2021.DAY04 do
  require Logger

  def run() do
    Logger.info("AOC 2021 Day 4")

    case open_file_contents("inputs/day04.input") do
      {:ok, contents} ->
        [balls, cards] = generate_bingo_game(contents, false)
        {:ok, ball, card} = play_winning_bingo(cards, balls)
        card_sum = calculate_sum(card, 0)
        Logger.info("Part One - Ball: #{ball} Card Sum: #{card_sum} Answer: #{card_sum * ball}")

        {:ok, ball, card} = play_losing_bingo(cards, balls)
        card_sum = calculate_sum(card, 0)

        Logger.info("Part Two - Ball: #{ball} Card Sum: #{card_sum} Answer: #{card_sum * ball}")

        {:ok}

      {:error, _error} ->
        {:error}
    end
  end

  def open_file_contents(path) do
    case File.read(path) do
      {:ok, input} ->
        {:ok, input |> String.split("\n", trim: true)}

      {:error, error} ->
        {:error, error}
    end
  end

  def generate_bingo_game(contents, default) do
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

  def play_winning_bingo(cards, [ball | balls]) do
    cards = Enum.map(cards, fn card -> card |> Enum.map(&daub(&1, ball, [])) end)

    case find_winning_card(cards) do
      {:ok, card} -> {:ok, ball, card}
      {:skip} -> play_winning_bingo(cards, balls)
    end
  end

  def play_winning_bingo(_, []), do: {:ok}

  def play_losing_bingo(cards, [ball | balls]) do
    cards = Enum.map(cards, fn card -> card |> Enum.map(&daub(&1, ball, [])) end)

    case filter_winning_cards(cards, []) do
      [] ->
        [card] = cards
        {:ok, ball, card}

      cards ->
        play_losing_bingo(cards, balls)
    end
  end

  def play_losing_bingo(_, []), do: {:none}

  def find_winning_card([card | cards]) do
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

  def find_winning_card([]), do: {:skip}

  def find_winning_row_column([row | rows]) do
    case row |> Enum.reduce(true, fn {_, b}, acc -> b && acc end) do
      false -> find_winning_row_column(rows)
      true -> {:ok}
    end
  end

  def find_winning_row_column([]), do: {:skip}

  def filter_winning_cards([card | cards], acc) do
    case find_winning_card([card]) do
      {:ok, _card} -> filter_winning_cards(cards, acc)
      {:skip} -> filter_winning_cards(cards, [card] ++ acc)
    end
  end

  def filter_winning_cards([], acc), do: acc

  def calculate_sum([row | rows], acc),
    do: calculate_sum(rows, Enum.reduce(row, 0, &reduce_val/2) + acc)

  def calculate_sum([], acc), do: acc

  def reduce_val({_, true}, acc), do: acc
  def reduce_val({v, false}, acc), do: v + acc

  def daub([{n, b} | t], ball, acc), do: daub(t, ball, [{n, b || n == ball}] ++ acc)
  def daub([], _, acc), do: acc
end
