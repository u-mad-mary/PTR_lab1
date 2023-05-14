defmodule MessageBroker do
  use Application

  @impl true
  def start(_type, _args) do

    publisher_port = String.to_integer(System.get_env("PUB_PORT") || "23")
    consumer_port = String.to_integer(System.get_env("CONS_PORT") || "24")

    children = [
      {DataSuper, []},
      {ConsumerSuper, []},
      {Task.Supervisor, name: MessageBroker},
      Supervisor.child_spec({Task, fn -> ConsumerServ.accept(consumer_port) end}, restart: :permanent, id: :consumer_server),
      Supervisor.child_spec({Task, fn -> Publisher.accept(publisher_port) end}, restart: :permanent, id: :publisher_server)
    ]

    opts = [strategy: :one_for_one, name: MessageBroker.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
