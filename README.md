## Laboratory Work No.0
The first (zero) laboratory work on "Programarea în Timp Real” course.

### Instructions
Firstly install Elixir, this can be done by following the steps from the 
official Elixir [documentation](https://elixir-lang.org/install.html).

The program can be executed by running unit tests:
```erlang
mix test
```
Or by calling specific functions:
```erlang
iex -S mix
iex(1)> WEEK2.hello()
```
Where **WEEK2** is the module name and **hello()** is the called function.

For the third week use:
```erlang
iex -S mix
iex(1)> pid = _MODULE_NAME_.start
iex(2)> send(pid, VALUE)
```
to start an actor, where _MODULE_NAME_ is the name of the Actor, and VALUE is the value you want to input for example for starting the Modifier actor call and inputing something use::
```erlang
iex -S mix
iex(1)> pid = Modifier.start
iex(2)> send(pid, 10)
```
It will print:
```text
Received: 10
10
```

To avoid printing the inputed data, can be used the following command:
```erlang
iex(2)> spawn fn -> send(pid, 10) end
```
