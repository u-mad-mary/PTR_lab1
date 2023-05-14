defmodule Consumers do
  require Logger
  use GenServer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_args) do
    {:ok, %{}}
  end

  def subscribe(pid, topic) do
    GenServer.cast(__MODULE__, {:subscribe, pid, topic})
  end

  def unsubscribe(pid, topic) do
    GenServer.cast(__MODULE__, {:unsubscribe, pid, topic})
  end

  def send_data(topic, data) do
    GenServer.cast(__MODULE__, {:send_data, topic, data})
  end

  def handle_cast({:subscribe, pid, topic}, state) do
    Logger.info("^^^ Subscribing consumer #{inspect(pid)} to topic > #{topic} < ^^^")
    new_state = Map.update(state, topic, [pid], fn consumers -> [pid | consumers] end)
    {:noreply, new_state}
  end

  def handle_cast({:unsubscribe, pid, topic}, state) do
    Logger.info("^^^ Unsubscribing consumer #{inspect pid} from topic > #{topic} < ^^^")
    new_state = Map.update(state, topic, [], fn consumers -> List.delete(consumers, pid) end)
    {:noreply, new_state}
  end

  def handle_cast({:send_data, topic, data}, state) do
    Logger.info("^^^ Send data to consumers of topic > #{topic} < ^^^")
    state = Map.update(state, topic, [], fn consumers -> consumers end)
    Enum.each(state[topic], fn pid -> Consumer.send_data(pid, topic, data) end)
    {:noreply, state}
  end
end
