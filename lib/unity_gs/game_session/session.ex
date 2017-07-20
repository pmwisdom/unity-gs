defmodule UnityGs.Game.Session do
  use GenServer

  defstruct [
    id: nil,
    name: nil,
    number_max_players: 2,
    players: %{},
    in_progress: false
  ]

  def start_link(id, name) do
    GenServer.start_link(__MODULE__, %__MODULE__{id: id, name: name}, name: ref(id));
  end

  def init(state) do
    IO.puts "Initialized Game Session with:"
    IO.inspect state

    UnityGs.Game.Event.game_created

    {:ok, state}
  end

  def join(game_id, player_id, pid) do
    IO.puts "Joining #{game_id}"
    try_call(game_id, {:join, player_id, pid})
  end

  def leave(game_id, player_id, pid) do
    try_call(game_id, {:leave, player_id, pid})
  end

  def handle_call({:join, player_id, pid}, _from, state) do
    IO.puts "Atttempting to join #{player_id}"
    cond do
      Map.has_key?(state.players, player_id) -> {:reply, {:error, "You have already joined this game"}, state}
      Enum.count(Map.keys(state.players)) >= state.number_max_players -> {:reply, {:error, "Too many players in game"}, state}
      true ->
        new_state = %{state | players: Map.put_new(state.players, player_id, %Player{id: player_id})}

        UnityGs.Game.Event.player_joined

        {:reply, {:ok, self}, new_state}
    end
  end

  def handle_call({:leave, player_id, pid}, _from, state) do
    new_state = %{
      state | players: Map.pop(state.players, player_id)
    }

    UnityGs.Game.Event.player_left

    {:reply, {:ok, self}, new_state}

  end

  def handle_call(:get_data, _from, state), do: {:reply, state, state}

  def handle_call(_, state) do
    {:reply, state}
  end

  def handle_cast(_, state) do
    {:noreply, state}
  end

  # Generates global reference
  defp ref(id), do: {:global, {:game, id}}

  defp try_call(id, payload) do
    case GenServer.whereis(ref(id)) do
      nil ->
        {:error, "Game does not exist"}
      game ->
        GenServer.call(game, payload)
    end
  end
end
