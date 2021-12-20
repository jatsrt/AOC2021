defmodule AOC2021.DAY04 do
  def run() do
    IO.puts("AOC 2021 Day 4")

    [balls | cards] = "inputs/day04.input" |> File.read!() |> String.split("\n\n", trim: true)
    balls = balls |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1)
    cards = cards |> Enum.map(fn card -> card |> String.split("\n", trim: true) |> Enum.map(fn row -> row |> String.split(" ", trim: true) |> Enum.map(&{String.to_integer(&1), false}) end) end)

    {ball, card} = play_win(balls, cards)
    card_sum = card |> List.flatten() |> Enum.flat_map(fn {v, marked} -> if marked, do: [], else: [v] end) |> Enum.sum()
    IO.puts("Part One - Ball: #{ball} Card Sum: #{card_sum} Answer: #{card_sum * ball}")

    {ball, card} = play_lose(balls, cards)
    card_sum = card |> List.flatten() |> Enum.flat_map(fn {v, marked} -> if marked, do: [], else: [v] end) |> Enum.sum()
    IO.puts("Part Two - Ball: #{ball} Card Sum: #{card_sum} Answer: #{card_sum * ball}")
  end

  defp play_win([ball | balls], cards) do
    cards = cards |> Enum.map(&daub(ball, &1))
    winners = Enum.filter(cards, &complete?/1)

    if Enum.empty?(winners) do
      play_win(balls, cards)
    else
      {ball, List.first(winners)}
    end
  end

  defp play_lose([ball | balls], cards) do
    cards = cards |> Enum.map(&daub(ball, &1))
    {winners, losers} = Enum.split_with(cards, &complete?/1)

    if Enum.empty?(losers) do
      {ball, winners |> List.first()}
    else
      play_lose(balls, losers)
    end
  end

  defp daub(ball, card), do: Enum.map(card, &daub_row(ball, &1))

  def daub_row(_, []), do: []
  def daub_row(ball, [{n, _} | row]) when n == ball, do: [{n, true} | row]
  def daub_row(ball, [cell | row]), do: [cell | daub_row(ball, row)]

  def complete?(card),
    do:
      Enum.any?(card, fn row -> Enum.all?(row, fn {_, marked} -> marked end) end) ||
        Enum.any?(Enum.zip_with(card, & &1), fn col -> Enum.all?(col, fn {_, marked} -> marked end) end)
end
