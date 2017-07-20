defmodule UnityGs.LobbyChannel do
  use UnityGs.Web, :channel

  alias UnityGs.Game.Supervisor, as: GameSupervisor

  def join("lobby", _payload, socket) do
      {:ok, socket}
  end

  def handle_in("get_current_games", _params, socket) do
    IO.puts "Retreiving current games"
    IO.inspect GameSupervisor.current_games
    {:reply, {:ok, %{games: GameSupervisor.current_games}}, socket}
  end

  def handle_in("create_game", %{"name" => game_name}, socket) do
    IO.puts "Creating Game with " <> game_name

    game_id = UnityGs.generate_game_id
    GameSupervisor.create_game(game_id, game_name)

    {:reply, {:ok, %{game_id: game_id}}, socket}
  end

  def handle_in(_name) do
    IO.puts "No Handle in was sent for this call"
    {:reply, {:error}}
  end

  def broadcast_current_games do
    IO.puts "Broadcasting current games from LobbyChannel"

    UnityGs.Endpoint.broadcast("lobby", "games_updated", %{games: GameSupervisor.current_games})
  end
end
