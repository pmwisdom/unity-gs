defmodule UnityGs.Game.EventHandler do
  use GenEvent
  alias UnityGs.{LobbyChannel}

  # def handle_event({:game_stopped, game_id}, state) do
  #   GameChannel.broadcast_stop(game_id)
  #
  #   {:ok, state}
  # end
  def handle_event(:game_created, state), do: broadcast_lobby_update(state)
  def handle_event(:player_joined, state), do: broadcast_lobby_update(state)
  def handle_event(:game_over, state), do: broadcast_lobby_update(state)
  def handle_event(_, state), do: {:ok, state}

  defp broadcast_lobby_update(state) do
    LobbyChannel.broadcast_current_games

    {:ok, state}
  end
end
