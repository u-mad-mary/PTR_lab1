defmodule Data do
  require Logger
  use GenServer

  def start_link(topic) do
    GenServer.start_link(__MODULE__, topic)
  end

  def init(topic) do
    table_name = String.to_atom(topic)
    case :dets.open_file(table_name, [{:type, :set}, {:keypos, 1}]) do
      {:ok, table} ->
        Logger.info("^^^ Topic > #{topic} < created ^^^")
        {:ok, {topic, table}}
      {:error, reason} ->
        Logger.error("=== Module: #{__MODULE__} creating topic #{topic}: #{inspect(reason)} ===")
        {:stop, reason}
    end
  end

  def publish(pid, data) do
    GenServer.cast(pid, {:publish, data})
  end

  def get_data(pid) do
    GenServer.call(pid, :get_data)
  end

  def handle_cast({:publish, data}, {topic, table}) do
    Consumers.send_data(topic, data)
    date = DateTime.utc_now()
    :dets.insert(table, {date, data})
    {:noreply, {topic, table}}
  end

  def handle_call(:get_data, _from, {topic, table}) do
    case :dets.foldl(fn elem, acc -> [elem | acc] end, [], table) do
      {:error, reason} ->
        Logger.error("=== Module: #{__MODULE__} Error getting data from topic > #{topic} <: #{inspect(reason)} ===")
        {:reply, [], {topic, table}}
      mess ->
        {:reply, mess, {topic, table}}
    end
  end

  def terminate(_reason, {_, table}) do
    :dets.close(table)
    :ok
  end
end
