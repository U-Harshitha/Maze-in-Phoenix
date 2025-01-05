defmodule PhoenixmazeWeb.MazeLive.Timer do
  @moduledoc """
  A module to calculate timer values for the maze game.
  Handles countdown, percentage calculation, and color updates.
  """

  @doc """
  Calculates the new countdown, percentage of time left, and the timer color.

  ## Parameters
    - `current_countdown`: The current value of the countdown timer.
    - `interval`: The total interval in milliseconds.

  ## Returns
    A tuple `{new_countdown, percentage, color}`:
      - `new_countdown`: Updated countdown value.
      - `percentage`: Percentage of the timer completed.
      - `color`: Timer color ("green", "orange", or "red").
  """
  def calculate_timer_values(current_countdown, interval) do
    # Decrement the countdown, ensuring it does not go below 0
    new_countdown = max(0, current_countdown - 1)
    total_time = div(interval, 1000)
    percentage = new_countdown / total_time * 100

    color =
      cond do
        percentage > 75 -> "green"
        percentage > 50 -> "yellow"
        percentage > 25 -> "orange"
        true -> "red"
      end

    # Optional: Handle logic when the countdown reaches 0
    if new_countdown == 0 do
      handle_timer_end()
    end

    {new_countdown, percentage, color}
  end

  @doc """
  Optional function to handle timer end logic.

  This can be extended to trigger actions like resetting the timer,
  notifying the user, or performing other custom tasks.
  """
  defp handle_timer_end do
    # Add your custom logic here, e.g., logging or resetting
    IO.puts("Timer has ended!")
  end
end
