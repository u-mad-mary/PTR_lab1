defmodule Cache do
  use Agent

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get(key) do
    Agent.get(__MODULE__, fn state ->
      Map.has_key?(state, key)
    end)
  end

  def put(key) do
    Agent.update(__MODULE__, fn state ->
      Map.put(state, key, true)
    end)
  end
end
