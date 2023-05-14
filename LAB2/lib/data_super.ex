defmodule DataSuper do
  require Logger
  use Supervisor

  def start_link(_args) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    Supervisor.init([], strategy: :one_for_one)
  end

  def publish(topic, data) do
    case get_worker_pid(topic) do
      nil ->
        case new_topic(topic) do
          {:ok, pid} ->
            Data.publish(pid, data)
          {:error} ->
            Logger.info("=== Module: #{__MODULE__} Error with publishing the data on topic -> #{topic} ===")
        end
      pid ->
        Data.publish(pid, data)
    end
  end


  def get_data(topic) do
    case get_worker_pid(topic) do
      nil ->
        case new_topic(topic) do
          {:ok, pid} ->
            Data.get_data(pid)
          {:error} ->
            Logger.error("=== Module: #{__MODULE__} Error with getting data from topic -> #{topic} ===")
        end
      pid ->
        Data.get_data(pid)
    end
  end

  def new_topic(topic) do
    case Supervisor.start_child(__MODULE__, %{
      id: topic,
      start: {Data, :start_link, [topic]}
    }) do
      {:ok, pid} ->
        Logger.info("^^^ Topic with name > #{topic} < is created ^^^")
        {:ok, pid}
      {:error, _} ->
        Logger.info("=== Module: #{__MODULE__} Error creating topic #{topic} ===")
        {:error}
    end
  end

  def get_worker_pid(id) do
    case Supervisor.which_children(__MODULE__)
    |> Enum.find(fn {i, _, _, _} -> i == id end) do
      {_, pid, _, _} -> pid
      nil -> nil
    end
  end
end
