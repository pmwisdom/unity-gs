defmodule UnityGs.Game.Supervisor do
  require Logger

  use Supervisor

  alias UnityGs.Game.{Session}

  def start_link do
     IO.puts "Game Supervisor Link Starting Up WOOOOOOOO"
     Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(Session, [], restart: :temporary)
    ]

    IO.puts "Supervisor Starting up"

    supervise(children, strategy: :simple_one_for_one)
  end

  def create_game(id, name) do
    IO.puts "[GameSupervisor] Creating game with #{id} and #{name} WEOO"
    case Supervisor.start_child(__MODULE__, [id, name]) do
      {:ok, pid} ->
        IO.puts "Received OK from supervisor AYYY"
        IO.inspect pid
      shit ->
        IO.puts "Did not start child correctly"
        IO.inspect shit
    end
  end

  def current_games do
    __MODULE__
      |> Supervisor.which_children
      |> Enum.map(&get_game_data/1)
  end

  def stop_game(game_id) do
    Logger.debug "Stopping game #{game_id} in supervisor"

    pid = GenServer.whereis({:global, {:game, game_id}})

    Supervisor.terminate_child(__MODULE__, pid)
  end


  defp get_game_data({_id, pid, _type, _modules}) do
    data = pid
    |> GenServer.call(:get_data)
    |> Map.take([:id, :players, :name])

    Map.put(data, :num_players, Enum.count(Map.keys(data.players)))
  end

end
