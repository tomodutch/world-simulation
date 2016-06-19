defmodule World.Farm do
  use Supervisor
  alias World.Time.Duration

  def start_link(registry, sup) do
    Supervisor.start_link(__MODULE__, {registry, sup}, [])
  end

  def init({registry, sup}) do
    duration = %Duration{amount: 1, name: :day}
    handler = World.Cabbage.SpawnHandler

    children = [
      worker(World.Registry, [[name: registry]]),
      worker(World.Spawner, [duration, handler, registry, sup, []]),
      supervisor(World.Cabbage.Supervisor, [[name: sup]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
