defmodule Phoenixmaze.MazeGen do
  alias __MODULE__, as: Maze
  defstruct n: 0, m: 0, maze: [], origin: {0, 0}, iterations: 0, walls: []

  def init_maze(n, m) when is_integer(n) and n > 0 and is_integer(m) and m > 0 do
    maze =
      for i <- 0..(n - 1) do
        for(_j <- 0..(m - 2), do: :right) ++
          if i == n - 1, do: [nil], else: [:down]
      end

    %Maze{
      n: n,
      m: m,
      maze: maze,
      origin: {n - 1, m - 1},
      iterations: n * m * 10,
      walls: initialize_walls(n, m)
    }
  end

  def init_maze(_n, _m) do
    raise ArgumentError, "Both n and m must be positive integers"
  end

  defp initialize_walls(n, m) do
    for _ <- 1..n do
      for _ <- 1..m do
        %{:up => true, :right => true, :left => true, :down => true}
      end
    end
  end

  def origin_adjs(%Maze{origin: {x, y}, n: n, m: m}) do
    [
      if(x > 0, do: {x - 1, y, :up}, else: nil),
      if(x < n - 1, do: {x + 1, y, :down}, else: nil),
      if(y > 0, do: {x, y - 1, :left}, else: nil),
      if(y < m - 1, do: {x, y + 1, :right}, else: nil)
    ]
    |> Enum.filter(& &1)
  end

  def make_maze_walls(%Maze{maze: maze, walls: walls} = maze_state) do
    new_walls =
      Enum.with_index(maze)
      |> Enum.reduce(walls, fn {row, i}, acc ->
        Enum.with_index(row)
        |> Enum.reduce(acc, fn {dir, j}, acc ->
          case dir do
            :right ->
              acc
              |> update_wall(i, j, :right, false)
              |> update_wall(i, j + 1, :left, false)

            :left ->
              acc
              |> update_wall(i, j, :left, false)
              |> update_wall(i, j - 1, :right, false)

            :up ->
              acc
              |> update_wall(i, j, :up, false)
              |> update_wall(i - 1, j, :down, false)

            :down ->
              acc
              |> update_wall(i, j, :down, false)
              |> update_wall(i + 1, j, :up, false)

            _ ->
              acc
          end
        end)
      end)

    %Maze{maze_state | walls: new_walls}
  end

  defp update_wall(walls, i, j, direction, value) do
    if i >= 0 and j >= 0 and i < length(walls) and j < length(hd(walls)) do
      List.update_at(walls, i, fn row ->
        List.update_at(row, j, &Map.put(&1, direction, value))
      end)
    else
      walls
    end
  end

  def generate_new_maze(n, m) do
    maze_state = init_maze(n, m)

    Enum.reduce(1..maze_state.iterations, maze_state, fn _, acc ->
      new_origin = Enum.random(origin_adjs(acc))
      {x, y, dir} = new_origin

      updated_maze =
        List.update_at(acc.maze, elem(acc.origin, 0), fn row ->
          List.replace_at(row, elem(acc.origin, 1), dir)
        end)

      updated_maze =
        List.update_at(updated_maze, x, fn row ->
          List.replace_at(row, y, nil)
        end)

      %Maze{acc | maze: updated_maze, origin: {x, y}}
    end)
    |> make_maze_walls()
  end

  def format_walls(%Maze{walls: walls}) do
    for row <- walls do
      for cell <- row do
        {
          cell[:up],
          cell[:right],
          cell[:left],
          cell[:down]
        }
      end
    end
  end

  def print_formatted_maze(%Maze{} = maze_state) do
    formatted = format_walls(maze_state)
    IO.puts("maze = [")

    Enum.each(formatted, fn row ->
      IO.puts("  #{inspect(row)},")
    end)

    IO.puts("]")
  end
end

# Example Usage:
# maze_state = Maze.generate_new_maze(10, 10)
# Maze.print_formatted_maze(maze_state)
