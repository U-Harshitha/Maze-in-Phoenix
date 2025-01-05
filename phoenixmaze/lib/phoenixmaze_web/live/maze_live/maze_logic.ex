alias Phoenixmaze.MazeGen

defmodule PhoenixmazeWeb.MazeLive.MazeLogic do
  defstruct [
    :maze,
    :rows,
    :cols,
    :object_position,
    :countdown,
    :timer_percentage,
    :timer_color,
    :game_won
  ]

  @type t :: %__MODULE__{
          maze: list(list(tuple())),
          rows: integer(),
          cols: integer(),
          object_position: {integer(), integer()},
          countdown: integer(),
          timer_percentage: float(),
          timer_color: String.t(),
          game_won: boolean()
        }

  def calculate_new_position(key, {row, col}, maze, rows, cols) do
    current_cell = get_cell(maze, row, col)

    case key do
      "ArrowUp" ->
        upper_cell = if row > 0, do: get_cell(maze, row - 1, col)
        can_move_up = row > 0 && !elem(current_cell, 0) && !elem(upper_cell, 3)
        if can_move_up, do: {row - 1, col}, else: {row, col}

      "ArrowDown" ->
        lower_cell = if row < rows - 1, do: get_cell(maze, row + 1, col)
        can_move_down = row < rows - 1 && !elem(current_cell, 3) && !elem(lower_cell, 0)
        if can_move_down, do: {row + 1, col}, else: {row, col}

      "ArrowLeft" ->
        left_cell = if col > 0, do: get_cell(maze, row, col - 1)
        can_move_left = col > 0 && !elem(current_cell, 2) && !elem(left_cell, 1)
        if can_move_left, do: {row, col - 1}, else: {row, col}

      "ArrowRight" ->
        right_cell = if col < cols - 1, do: get_cell(maze, row, col + 1)
        can_move_right = col < cols - 1 && !elem(current_cell, 1) && !elem(right_cell, 2)
        if can_move_right, do: {row, col + 1}, else: {row, col}

      _ -> {row, col}
    end
  end

  def get_cell(maze, row, col) do
    maze
    |> Enum.at(row)
    |> Enum.at(col)
  end

  def generate_maze_from_gen(row, col) do
    generated_maze = MazeGen.generate_new_maze(row, col)
    MazeGen.format_walls(generated_maze)
  end

  def reset_game(state, maze, interval) do
    %{
      state
      | maze: maze,
        object_position: {0, 0},
        countdown: div(interval, 1000),
        timer_percentage: 100,
        timer_color: "green",
        game_won: false,
        points: 0
    }
  end
  def update_timer(state, new_countdown, interval) do
    percentage = new_countdown / div(interval, 1000) * 100
    color = get_timer_color(new_countdown)

    %{state | countdown: new_countdown, timer_percentage: percentage, timer_color: color}
  end
  defp get_timer_color(countdown) do
    cond do
      countdown > 10 -> "green"
      countdown > 5 -> "orange"
      true -> "red"
    end
  end

  # Check if destination is reached
  def check_win_condition({row, col}, destination) do
    if {row, col} == destination do
      :win
    else
      :continue
    end
  end
end
