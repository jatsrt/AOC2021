defmodule AOC2021.DAY12 do
  def upcase?(input), do: input == String.upcase(input)

  defmodule Graph do
    defstruct edges: %{}
    def new(), do: %Graph{}

    def add_edge(%Graph{edges: edges} = graph, v1, v2) do
      edges = Map.update(edges, v1, [v2], fn connections -> [v2 | connections] |> Enum.uniq() end)
      edges = Map.update(edges, v2, [v1], fn connections -> [v1 | connections] |> Enum.uniq() end)

      %{graph | edges: edges}
    end

    def add_edges(%Graph{} = graph, [{v1, v2} | t]) do
      add_edges(graph |> Graph.add_edge(v1, v2), t)
    end

    def add_edges(%Graph{} = graph, []), do: graph

    def edges(%Graph{edges: edges} = _graph, v), do: Map.get(edges, v, [])
  end

  def run() do
    IO.puts("AOC 2021 Day 12")

    contents =
      "inputs/day12.input"
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(fn path -> String.split(path, "-") |> Enum.map(&String.to_atom/1) |> List.to_tuple() end)

    graph = Graph.new() |> Graph.add_edges(contents)
    paths = build_paths(graph)
    IO.puts("Part One - #{length(paths)}")

    paths = build_paths(graph, false)
    IO.puts("Part Two - #{length(paths)}")
  end

  defp build_paths(graph, single \\ true, from \\ :start, to \\ [], path \\ [], paths \\ [])

  defp build_paths(graph, single, :start, [], [], paths) do
    verticies = graph |> Graph.edges(:start)
    build_paths(graph, single, :start, verticies, [:start], paths)
  end

  defp build_paths(_graph, _single, _from, _to, [:end | _] = path, paths),
    do: [path |> Enum.reverse() | paths]

  defp build_paths(graph, single, from, [to | t], path, paths) do
    paths = build_paths(graph, single, from, t, path, paths)

    verticies = graph |> Graph.edges(to)
    verticies = verticies -- [:start]

    visited_small_verticies = path |> Enum.filter(fn v -> !upcase?(v |> Atom.to_string()) end)

    high_count = [to | visited_small_verticies] |> Enum.frequencies() |> Map.values() |> Enum.max()

    case single || high_count > 1 do
      true ->
        verticies = verticies -- visited_small_verticies
        build_paths(graph, single, to, verticies, [to | path], paths)

      false ->
        build_paths(graph, single, to, verticies, [to | path], paths)
    end
  end

  defp build_paths(_graph, _single, _from, [], _path, paths), do: paths
end
