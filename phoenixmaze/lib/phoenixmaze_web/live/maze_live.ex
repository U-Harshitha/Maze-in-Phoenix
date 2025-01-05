defmodule PhoenixmazeWeb.MazeLive do
  use PhoenixmazeWeb, :live_view
  alias PhoenixmazeWeb.MazeLive.Timer
  alias PhoenixmazeWeb.MazeLive.MazeLogic

  @interval 15_000
  @timer_interval 1_000
  @video_duration 6_000

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Process.send_after(self(), :start_game, @video_duration)
    end

    maze = MazeLogic.generate_maze_from_gen(10, 10)

    {:ok,
    assign(socket,
      show_intro: true,
      maze: MazeLogic.generate_initial_maze(),
      rows: 10,
      cols: 10,
      object_position: {0, 0},
      countdown: div(@interval, 1000),
      timer_percentage: 100,
      timer_color: "white"
    )}
  end

  def handle_info(:start_game, socket) do
    maze = MazeLogic.generate_initial_maze()

    if connected?(socket) do
      :timer.send_interval(@interval, :regenerate_maze)
      :timer.send_interval(@timer_interval, :tick)
    end

    {:noreply,
     socket
     |> assign(:show_intro, false)
     |> assign(:maze, maze)
     |> assign(:rows, length(maze))
     |> assign(:cols, length(List.first(maze)))}
    {:ok,
     assign(socket,
       maze: nil,
       rows: nil,
       cols: nil,
       object_position: nil,
       countdown: nil,
       timer_percentage: nil,
       timer_color: nil,
       maze_dimensions_set: false,
       points: 0,  # Add points tracking
       show_success: false
     )}
  end

  embed_templates "maze_live/maze_live.html.heex"

  def handle_event("set_dimensions", %{"rows" => rows, "cols" => cols}, socket) do
    rows = String.to_integer(rows)
    cols = String.to_integer(cols)
    maze = MazeLogic.generate_maze_from_gen(rows, cols)

    {:noreply,
     assign(socket,
       maze: maze,
       rows: rows,
       cols: cols,
       object_position: {0, 0},
       countdown: div(@interval, 1000),
       timer_percentage: 100,
       timer_color: "green",
       maze_dimensions_set: true,
       points: 0,  # Reset points when starting new maze
       show_success: false
     )}
  end

  def handle_info(:regenerate_maze, socket) do
    new_maze = MazeLogic.generate_initial_maze()

      {:noreply,
       socket
       |> assign(:maze, new_maze)
       |> assign(:object_position, {0, 0})
       |> assign(:countdown, div(@interval, 1000))
       |> assign(:timer_percentage, 100)
       |> assign(:timer_color, "green")
       |> assign(:show_success, false)}
    else
      {:noreply, socket}
    end
  end

  def handle_info(:tick, socket) do
    if socket.assigns.maze_dimensions_set and not is_nil(socket.assigns.countdown) do
      {new_countdown, percentage, color} =
        Timer.calculate_timer_values(socket.assigns.countdown, @interval)

    {:noreply,
    socket
    |> assign(:countdown, new_countdown)
    |> assign(:timer_percentage, percentage)
    |> assign(:timer_color, color)}
  end

  def handle_event("move_object", %{"key" => key}, socket) do
    new_position =
      MazeLogic.calculate_new_position(
      key,
      socket.assigns.object_position,
      socket.assigns.maze,
      socket.assigns.rows,
      socket.assigns.cols
    )

    show_success = new_position == {socket.assigns.rows - 1, socket.assigns.cols - 1}
    points = if show_success, do: socket.assigns.points + 1, else: socket.assigns.points

    {:noreply,
     socket
     |> assign(:object_position, new_position)
     |> assign(:show_success, show_success)
     |> assign(:points, points)}
  end
  def handle_event("compete", _params, socket) do
    {:noreply, push_redirect(socket, to: Routes.maze_compete_path(socket, :new))}
  end


  def handle_event("play_again", _params, socket) do
    new_maze = MazeLogic.generate_maze_from_gen(socket.assigns.rows, socket.assigns.cols)

    {:noreply,
     socket
     |> assign(:maze, new_maze)
     |> assign(:object_position, {0, 0})  # Reset the object's position
     |> assign(:countdown, div(@interval, 1000))  # Reset the countdown
     |> assign(:timer_percentage, 100)  # Reset timer to full
     |> assign(:timer_color, "green")  # Reset the timer color
     |> assign(:show_success, false)}  # Hide success message
  end

end
