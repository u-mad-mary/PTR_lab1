defmodule ConsumerSuper do
  require Logger
  use Supervisor

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(_args) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    children = [
      {Consumers, []}
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end

  def create_consumer(socket) do
    case Supervisor.start_child(__MODULE__, %{
      id: set_id(),
      start: {Consumer, :start_link, [socket]}
    }) do
      {:ok, pid} ->
        Logger.info("^^^ Consumer #{inspect(pid)} created ^^^")
        {:ok, pid}
      {:error, _} ->
        Logger.info("=== Error creating consumer ===")
        {:error}
    end
  end

  defp set_id do
    UUID.uuid1()
  end
end
