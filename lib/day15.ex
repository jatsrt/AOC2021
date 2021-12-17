defmodule AOC2021.DAY15 do
  require Graph
  @chunk_size 100

  def run() do
    IO.puts("AOC 2021 Day 15")

    risk_levels =
      "inputs/day15.input"
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(fn line -> line |> String.split("", trim: true) |> Enum.map(&String.to_integer/1) |> Enum.with_index() end)
      |> Enum.with_index()
      |> Enum.map(fn {list, row} -> list |> Enum.map(fn {num, col} -> {{row, col}, num} end) end)
      |> List.flatten()
      |> Map.new()

    graph = Graph.new() |> Graph.add_vertices(risk_levels |> Map.keys())

    {x_s, y_s} = risk_levels |> Map.keys() |> Enum.unzip()
    {min_x, max_x} = mm_x = x_s |> Enum.min_max()
    {min_y, max_y} = mm_y = y_s |> Enum.min_max()

    verticies = graph |> Graph.vertices()
    graph = verticies |> Enum.reduce(graph, fn vertex, graph -> add_edges(graph, vertex, risk_levels, mm_x, mm_y) end)
    best_path = Graph.dijkstra(graph, {min_x, min_y}, {max_x, max_y})

    path_cost =
      best_path
      |> Enum.chunk_every(2, 1)
      |> Enum.map(fn
        [from, to] -> Graph.edge(graph, from, to) |> Map.get(:weight)
        _ -> 0
      end)
      |> Enum.sum()

    IO.puts("Part One - #{path_cost}")

    # TODO GROW THE GRAPH
    risk_levels =
      Enum.reduce(0..4, %{}, fn count, new_risk ->
        Map.merge(
          new_risk,
          risk_levels
          |> Enum.map(fn
            {{x, y}, v} when v + count == 9 -> {{x + count * @chunk_size, y}, 9}
            {{x, y}, v} -> {{x + count * @chunk_size, y}, rem(v + count, 9)}
          end)
          |> Map.new()
        )
      end)

    risk_levels =
      Enum.reduce(0..4, %{}, fn count, new_risk ->
        Map.merge(
          new_risk,
          risk_levels
          |> Enum.map(fn
            {{x, y}, v} when v + count == 9 -> {{x, y + count * @chunk_size}, 9}
            {{x, y}, v} -> {{x, y + count * @chunk_size}, rem(v + count, 9)}
          end)
          |> Map.new()
        )
      end)

    graph = Graph.new() |> Graph.add_vertices(risk_levels |> Map.keys())

    {x_s, y_s} = risk_levels |> Map.keys() |> Enum.unzip()
    {min_x, max_x} = mm_x = x_s |> Enum.min_max()
    {min_y, max_y} = mm_y = y_s |> Enum.min_max()

    verticies = graph |> Graph.vertices()
    graph = verticies |> Enum.reduce(graph, fn vertex, graph -> add_edges(graph, vertex, risk_levels, mm_x, mm_y) end)
    best_path = Graph.dijkstra(graph, {min_x, min_y}, {max_x, max_y})

    path_cost =
      best_path
      |> Enum.chunk_every(2, 1)
      |> Enum.map(fn
        [from, to] -> Graph.edge(graph, from, to) |> Map.get(:weight)
        _ -> 0
      end)
      |> Enum.sum()

    IO.puts("Part Two - #{path_cost}")
  end

  defp add_edges(graph, {x, y} = vertex, risk_levels, mm_x, mm_y) do
    graph
    |> add_edge(vertex, {x + 1, y}, risk_levels, mm_x, mm_y)
    |> add_edge(vertex, {x - 1, y}, risk_levels, mm_x, mm_y)
    |> add_edge(vertex, {x, y + 1}, risk_levels, mm_x, mm_y)
    |> add_edge(vertex, {x, y - 1}, risk_levels, mm_x, mm_y)
  end

  defp add_edge(graph, _, {x, y}, _, {min_x, max_x}, {min_y, max_y}) when x < min_x or x > max_x or y < min_y or y > max_y, do: graph
  defp add_edge(graph, vertex_from, vertex_to, risk_levels, _, _), do: graph |> Graph.add_edge(vertex_from, vertex_to, weight: Map.get(risk_levels, vertex_to))
end
