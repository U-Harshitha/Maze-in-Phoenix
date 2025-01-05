# PhoenixMaze: The Ultimate Maze Competition Platform

PhoenixMaze is a dynamic web application built using Elixir and Phoenix LiveView. It combines real-time interactivity with a seamless user experience.


## Features

### 🎮 Real-Time Maze Challenges
Compete with others in solving dynamically generated mazes. The real-time updates powered by Phoenix LiveView ensure a smooth and engaging experience.

### 🛠 Session Management
Utilizes `:ets` for session storage, ensuring lightning-fast and concurrent access to session data with robust fault tolerance.

### 🌐 Origin-Shift Algorithm
The Origin Shift Algorithm is a heuristic method often used in optimization problems to improve convergence by shifting the origin of the solution space. This technique helps avoid numerical instabilities and biases caused by fixed coordinate systems, enabling better exploration of complex landscapes.


## Tech Stack

### Backend
- **Elixir**: Concurrent, fault-tolerant, and designed for scalable systems.
- **Phoenix Framework**: The backbone for web development and real-time updates.
- **:ets**: High-performance in-memory storage for session management.

### Frontend
- **LiveView**: Reactive updates without JavaScript complexity.
- **HTML & CSS**: Simple yet effective design.

### Dev Tools
- **Mix**: Elixir's build tool for task automation.
- **Plug**: Modular components for request handling and middleware.


## Installation and Setup

1. **Clone the Repository**
   ```bash
   git clone https://github.com/your-username/phoenixmaze.git
   cd phoenixmaze
   ```

2. **Install Dependencies**
   ```bash
   mix deps.get
   ```

3. **Setup the Database** (if applicable)
   ```bash
   mix ecto.setup
   ```

4. **Start the Server**
   ```bash
   mix phx.server
   ```
   Visit `http://localhost:4000` to view the app.


## Roadmap

- Implementing ETS functionalities
- Add leaderboard functionality for competition tracking.
- Improve UI/UX with a more visually appealing design.
- Expand session storage to use distributed ETS tables for clustering.

Happy Coding! 🎉
