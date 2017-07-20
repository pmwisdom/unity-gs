defmodule UnityGs do
  use Application

  @id_length 8

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(UnityGs.Repo, []),
      # Start the endpoint when the application starts
      supervisor(UnityGs.Endpoint, []),
      # Start your own worker by calling: UnityGs.Worker.start_link(arg1, arg2, arg3)
      # worker(UnityGs.Worker, [arg1, arg2, arg3]),
      supervisor(UnityGs.Game.Supervisor, []),
      worker(UnityGs.Game.Event, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UnityGs.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    UnityGs.Endpoint.config_change(changed, removed)
    :ok
  end

  def generate_game_id do
    @id_length
    |> :crypto.strong_rand_bytes
    |> Base.url_encode64()
    |> binary_part(0, @id_length)
  end

end
