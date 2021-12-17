defmodule AOC2021.DAY11 do
  defmodule Octopus do
    use GenServer

    def start_link(opts), do: GenServer.start_link(__MODULE__, opts)

    def init(row: r, column: c, energy: e),
      do: {:ok, %{energy: e, blink: 0, step: 0, row: r, column: c}}

    def energy(pid), do: GenServer.call(pid, {:energy})
    def blink_count(pid), do: GenServer.call(pid, {:blink_count})
    @spec blink(atom | pid | {atom, any} | {:via, atom, any}, any) :: any
    def blink(pid, step), do: GenServer.call(pid, {:blink, step})

    def increment(pid), do: GenServer.cast(pid, {:increment})
    def increment(pid, row, column), do: GenServer.cast(pid, {:increment, row, column})
    def reset(pid, step), do: GenServer.cast(pid, {:reset, step})

    # Handlers
    def handle_call({:energy}, _from, %{energy: energy} = state), do: {:reply, energy, state}
    def handle_call({:blink_count}, _from, %{blink: blink} = state), do: {:reply, blink, state}

    def handle_call(
          {:blink, step},
          _from,
          %{energy: e, step: prev_step, blink: blink, row: row, column: column} = state
        )
        when e >= 10 and step != prev_step,
        do: {:reply, neighbors(row, column), %{state | blink: blink + 1, step: step}}

    def handle_call({:blink, _}, _from, state), do: {:reply, [], state}

    def handle_cast({:energy, amount}, state), do: {:noreply, %{state | energy: amount}}
    def handle_cast({:increment}, %{energy: e} = state), do: {:noreply, %{state | energy: e + 1}}

    def handle_cast({:increment, row, column}, %{energy: e, row: row, column: column} = state),
      do: {:noreply, %{state | energy: e + 1}}

    def handle_cast({:increment, _, _}, state), do: {:noreply, state}

    def handle_cast({:reset, step}, %{energy: e} = state) when e >= 10,
      do: {:noreply, %{state | step: step, energy: 0}}

    def handle_cast({:reset, step}, state), do: {:noreply, %{state | step: step}}

    defp neighbors(row, column),
      do: [{row, column - 1}, {row, column + 1}, {row - 1, column + 1}, {row - 1, column}, {row - 1, column - 1}, {row + 1, column + 1}, {row + 1, column}, {row + 1, column - 1}]
  end

  def run() do
    IO.puts("AOC 2021 Day 11 - Intro to GenServer")

    contents =
      "inputs/day11.input"
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(fn row -> row |> Enum.map(&String.to_integer/1) end)

    octopi = create_octopi(contents)

    process_steps(1..100 |> Enum.to_list(), octopi)
    blinks = octopi |> Enum.map(&Octopus.blink_count/1) |> Enum.sum()
    IO.puts("Part One - Total Blinks: #{blinks}")

    octopi = create_octopi(contents)
    final_step = process_all_blink(octopi)
    IO.puts("Part Two - All Blink At Step: #{final_step}")

    {:ok}
  end

  defp create_octopi(list, row \\ 0, acc \\ [])

  defp create_octopi([h | t], row, acc),
    do: create_octopi(t, row + 1, create_octopi_row(h, row, acc))

  defp create_octopi([], _, acc), do: acc

  defp create_octopi_row(list, row, column \\ 0, acc)

  defp create_octopi_row([h | t], row, column, acc) do
    {:ok, pid} = Octopus.start_link(row: row, column: column, energy: h)
    create_octopi_row(t, row, column + 1, acc ++ [pid])
  end

  defp create_octopi_row([], _, _, acc), do: acc

  defp process_steps([step | steps], octopi) do
    octopi |> Enum.map(&Octopus.increment/1)

    blink_them(octopi, step)

    octopi |> Enum.each(&Octopus.reset(&1, step))
    process_steps(steps, octopi)
  end

  defp process_steps([], _), do: {:ok}

  defp process_all_blink(list, step \\ 1)

  defp process_all_blink(octopi, step) do
    octopi |> Enum.map(&Octopus.increment/1)

    blink_them(octopi, step)
    octopi |> Enum.each(&Octopus.reset(&1, step))

    case octopi |> Enum.map(&Octopus.energy/1) |> Enum.sum() do
      0 -> step
      _ -> process_all_blink(octopi, step + 1)
    end
  end

  defp blink_them(octopi, step) do
    case octopi |> Enum.map(&Octopus.blink(&1, step)) |> List.flatten() do
      [] ->
        {:ok}

      neighbors ->
        increment_neighbors(neighbors, octopi)
        blink_them(octopi, step)
    end
  end

  defp increment_neighbors([{row, column} | t], octopi) do
    octopi |> Enum.each(&Octopus.increment(&1, row, column))
    increment_neighbors(t, octopi)
  end

  defp increment_neighbors([], _), do: {:ok}
end
