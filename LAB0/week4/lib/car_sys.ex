defmodule CarSensorSystem do
  use Application

  def start(_type, :normal) do
    IO.puts("Starting the car...")
    children = [
      {MainSensorSupervisor, []}
    ]
    opts = [strategy: :one_for_all]
    Supervisor.start_link(children, opts)
  end

end

defmodule MainSensorSupervisor do
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, [])
  end

  def init(_) do
    children = [
      WheelsSensorSupervisor,
      Sensor.child_spec(:cabin, id: :cabin_sensor),
      Sensor.child_spec(:motor, id: :motor_sensor),
      Sensor.child_spec(:chassis, id: :chassis_sensor)
    ]

    Supervisor.init(children, strategy: :one_for_one, max_restarts: 2)
  end


  def kill(sensor) do
    GenServer.call(sensor, :kill)
    receive do
      {:EXIT, ^sensor, reason} -> reason
    end
  end

end

defmodule WheelsSensorSupervisor do
  use Supervisor

  def start_link(name) do
    Supervisor.start_link(__MODULE__, name)
  end

  def init(_) do
    children = [
      Sensor.child_spec(:wheel1, id: :sensor_wheel1),
      Sensor.child_spec(:wheel2, id: :sensor_wheel2),
      Sensor.child_spec(:wheel3, id: :sensor_wheel3),
      Sensor.child_spec(:wheel4, id: :sensor_wheel4)
    ]

    Supervisor.init(children, strategy: :one_for_one)
    |> tap(fn _ -> IO.puts("Deployed Airbag") end)
  end
end

defmodule Sensor do
  use GenServer


  def start_link(name) do
    IO.puts("Starting the #{name} sensor")
    GenServer.start_link(__MODULE__, name)
  end

  def init(name) do
    Process.register(self(), name)
    {:ok, name}
  end

  def handle_call(:kill, _from, state) do
    Process.exit(self(), :killed)
    {:noreply, state}
  end

  def child_spec(name, opts) do
    %{
      id: Keyword.get(opts, :id, name),
      start: {__MODULE__, :start_link, [name]},
      type: :worker,
      restart: :transient
    }
  end
end

# CarSensorSystem.start([], :normal)
# MainSensorSupervisor.kill(:cabin)
