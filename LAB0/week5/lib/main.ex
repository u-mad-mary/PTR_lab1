defmodule SWA do
  use Application
  require Logger

  def start(_type, _args) do
    Logger.info("Starting the app...")

    children = [
      {Plug.Cowboy, scheme: :http, plug: Endpoints, options: [port: port()]},
      {ETS_DataBase, []}
    ]

    Logger.info "The server has started at port: #{port()}..."
    opts = [strategy: :one_for_one]

    Supervisor.start_link(children, opts)

  end

  defp port(), do: Application.get_env(:SWA, :port, 8000)

end

defmodule Endpoints do

  use Plug.Router

  plug Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason

  plug :match
  plug :dispatch


  get "/movies" do
    json(conn, :ok, ETS_DataBase.call_server({:get_movies, []}))
  end

  get "/movies/:id" do
    id = String.to_integer(conn.params["id"])
    json(conn, :ok, ETS_DataBase.call_server({:get_movie, id}))
  end

  post "/movies" do
    json(conn, 201, ETS_DataBase.call_server({:create_movie, conn.body_params}))
  end

  put "/movies/:id" do
    id = String.to_integer(conn.params["id"])
    json(conn, :ok, ETS_DataBase.call_server({:update_movie, id, conn.body_params }))
  end

  patch "/movies/:id" do
    id = String.to_integer(conn.params["id"])
    json(conn, :ok, ETS_DataBase.call_server({:update_movie_attributes, id, conn.body_params }))
  end

  delete "/movies/:id" do
    id = String.to_integer(conn.params["id"])
    ETS_DataBase.call_server({:delete_movie, id})
    send_resp(conn, :no_content , "")
  end

  match _ do
    json(conn, :not_found, %{error: "Not Found"})
  end

  def json(conn, status, body) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(body))
  end

end

defmodule ETS_DataBase do
  use GenServer

  @movies [%{
    id: 1,
    title: "Star Wars: Episode IV - A New Hope",
    director: "George Lucas",
    release_year: 1977
  },
  %{
    id: 2,
    title: "Star Wars: Episode V - The Empire Strikes Back",
    director: "Irvin Kershner",
    release_year: 1980
  },
  %{
    id: 3,
    title: "Star Wars: Episode VI - Return of the Jedi",
    director: "Richard Marquand",
    release_year: 1983
  },
  %{
    id: 4,
    title: "Star Wars: Episode I - The Phantom Menace",
    director: "George Lucas",
    release_year: 1999
  },
  %{
    id: 5,
    title: "Star Wars: Episode II - Attack of the Clones",
    director: "George Lucas",
    release_year: 2002
  },
  %{
    id: 6,
    title: "Star Wars: Episode III - Revenge of the Sith",
    director: "George Lucas",
    release_year: 2005
  },
  %{
    id: 7,
    title: "Star Wars: Episode VII - The Force Awakens",
    director: "J.J. Abrams",
    release_year: 2015
  },
  %{
    id: 8,
    title: "Star Wars: Episode VIII - The Last Jedi",
    director: "Rian Johnson",
    release_year: 2017
  },
  %{
    id: 9,
    title: "Star Wars: Episode IX - The Rise of Skywalker",
    director: "J.J. Abrams",
    release_year: 2019
  },
  %{
    id: 10,
    title: "Star Wars: Episode III - Revenge of the Sith",
    director: "George Lucas",
    release_year: 2005
  }]


  def start_link(_opts) do
    GenServer.start_link(__MODULE__, @movies, name: __MODULE__)
  end




  def init(movies) do
    table = :ets.new(:session, [:set, :public, :named_table])
    populate_table(table, movies)
    {:ok, table}
  end

  def populate_table(_table, []) do
    :ok
  end

  def populate_table(table, [movie | rest]) do
    :ets.insert(table, {movie[:id], movie})
    populate_table(table, rest)
  end

  def handle_call({:get_movies, []}, _from, table) do
    movies = :ets.tab2list(table)
    |> Enum.sort_by(fn {key, _} -> key end)
    |> Enum.reduce([], fn {key, movie}, acc ->
      [Map.put(movie, :id, key) | acc]
    end)
    |> Enum.reverse()
    {:reply, movies, table}
  end

  def handle_call({:get_movie, id}, _from, table) do
    case :ets.lookup(table, id) do
      [] ->
        {:reply, nil, table}
      [{key, movie}] ->
        {:reply, %{movie | id: key}, table}
    end
  end

  def handle_call({:create_movie, movie}, _from, table) do
    max_id = :ets.info(table, :size)
    used_ids = :ets.tab2list(table) |> Enum.map(&elem(&1, 0))

    next_id =
      case Enum.find(1..max_id, fn id -> id not in used_ids end) do
        nil -> max_id + 1
        id -> id
      end

    created_movie = Map.put(movie, :id, next_id)
    :ets.insert(table, {next_id, created_movie})
    {:reply, created_movie, table}
  end

  def handle_call({:update_movie, id, movie}, _from, table) do
    updated_movie = Map.put(movie, :id, id)
    :ets.insert(table, {id, updated_movie})
    {:reply, updated_movie, table}
  end

  def handle_call({:update_movie_attributes, id, attrs}, _from, table) do
    case :ets.lookup(table, id) do
      [] ->
        {:reply, nil, table}

      [{key, movie}] ->
        updated_movie = Map.merge(movie, attrs)
        :ets.insert(table, {id, updated_movie})
        {:reply, %{updated_movie | id: key}, table}
    end
  end

  def handle_call({:delete_movie, id}, _from, table) do
    :ets.delete(table, id)
    {:reply, :deleted, table}
  end

  def call_server({func_name, arg1}) do
    GenServer.call(__MODULE__, {func_name, arg1})
  end

  def call_server({func_name, arg1, arg2}) do
    GenServer.call(__MODULE__, {func_name, arg1, arg2})
  end

end

# SWA.start([], :normal)
# curl http://localhost:8000/movies
# curl http://localhost:8000/movies/1
# curl -X POST -H "Content-Type: application/json" http://localhost:8000/movies
# curl -X PUT -H "Content-Type: application/json" -d '{"title": "Star Wars: Episode X - The New Beginning"}' http://localhost:8000/movies/11
# curl -X PATCH -H "Content-Type: application/json" -d '{"director": "Jane Smith"}' http://localhost:8000/movies/11
# curl -X DELETE http://localhost:8000/movies/11
