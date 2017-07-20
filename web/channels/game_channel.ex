defmodule UnityGs.GameChannel do
  use UnityGs.Web, :channel

  alias UnityGs.Game.Session

  def join("game:" <> game_id, payload, socket) do
    player_id = socket.assigns.user_id;

    IO.puts "Joining Game #{game_id} for #{player_id}"

    case Session.join(game_id, player_id, socket.channel_pid) do
      {:ok, pid} ->
        {:ok, assign(socket, :game_id, game_id)}
      {:error, reason} -> {:error, %{reason: reason}}
    end
  end

  def leave("game:leave", _payload, socket) do
    player_id = socket.assigns.user_id
    game_id = socket.assigns.game_id

    case Session.leave(game_id, player_id, socket.channel_pid) do
      {:ok, game} ->
        broadcast(socket, "game:player_left", %{player_id: player_id})

        :ok
      _ ->
        :ok
    end
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
