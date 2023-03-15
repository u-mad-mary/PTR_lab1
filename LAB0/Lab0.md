# FAF.PTR16.1 -- Project 0

**Performed by:** Maria-Mădălina Ungureanu, group FAF-203

**Verified by:** asist. univ. Alexandru Osadcenco

## P0W1

**Task 1** -- Follow an installation guide to install the language / development environ-ment of your choice.

DONE

**Task 2** -- Write a script that would print the message “Hello PTR” on the screen.
Execute it.

```elixir
defmodule WEEK1 do

  def hello do
    IO.puts("HELLo, PTR!")
    "HELLo, PTR!"
  end

end
```

**Task 3** -- Initialize a VCS repository for your project. Push your project to a remote repo.

DONE

**Task 4** -- Write a comprehensive readme for your repository.

DONE

**Task 5** -- Create a unit test for your project. Execute it.

```elixir
defmodule WEEK1Test do
  use ExUnit.Case
  doctest WEEK1

  test "PTR greetings" do
    assert WEEK1.hello() == "HELLo, PTR!"
  end
end
```

## P0W2

**Task 1** -- Write a function that determines whether an input integer is prime.

```elixir
  def isPrime(n) do
    if n <= 1 do
      false
    else
      Enum.all?(2..(n - 1), fn i -> rem(n, i) != 0 || n == 2 end)
    end
  end
```

This Elixir code defines a function called isPrime that takes an integer n as input and returns true if n is a prime number, and false otherwise.

If n is greater than 1, the code uses the Enum.all? function to iterate over the range 2..(n-1) and check if any of the numbers in that range divide n evenly (i.e., if the remainder of n divided by i is 0).

**Task 2** -- Write a function to calculate the area of a cylinder, given it’s height and
radius.

```elixir
  def cylinderArea(r, h) do
    if (r || h) <= 0 do
      IO.puts("The numbers must be grater than 0.")
    else
          2 * :math.pi * r * (r + h)
    end
  end
```

In summary, this function calculates the surface area of a cylinder given its radius and height, but only if both values are positive numbers. If either value is zero or negative, it outputs an error message.

**Task 5** -- Write a function to reverse a list.

```elixir
  def reverse(list) do
    Enum.reverse(list)
  end
```

The function body calls the built-in Enum.reverse function on the list argument and returns the result.

**Task 6** -- Write a function to calculate the sum of unique elements in a list.

```elixir
  def uniqueSum(list) do
    list
    |> Enum.uniq()
    |> Enum.sum()
  end
```

The function first applies the Enum.uniq() function to the list to remove any duplicate elements.

Then it applies the Enum.sum() function to the resulting list to calculate the sum of all elements in the list.

**Task 7** -- Write a function that extracts a given number of randomly selected elements
from a list.

```elixir
  def extractRandomN(list, n) do
    Enum.take_random(list, n)
  end
```

The function uses the "Enum.take_random" function from the Elixir standard library to randomly select and return n elements from the list.

**Task 8** -- Write a function that returns the first n elements of the Fibonacci sequence.

```elixir
  def fibonacci(0), do: 0
  def fibonacci(1), do: 1
  def fibonacci(n), do: fibonacci(n-1) + fibonacci(n-2)
  def firstFibonacciElements(n) do
    Enum.map(1..n, fn i -> fibonacci(i) end)
  end
```

The first two lines specify that when the input is 0 or 1, the output is 0 or 1 respectively. The third line is a recursive call to the fibonacci function for any other input n, which calculates the sum of the previous two Fibonacci numbers.

The last function, "firstFibonacciElements", takes an input n and uses the "Enum.map" function to apply the "fibonacci" function to each integer in the range from 1 to n, returning a list of the first n Fibonacci numbers.

**Task 9** -- Write a function that, given a dictionary, would translate a sentence. Words not found in the dictionary need not be translated.

```elixir
  def translator(dict, str) do
    list = String.split(str, " ")
    Enum.map(list, fn word -> Map.get(dict, word, word) end)
    |> Enum.join(" ")
  end
```

The function splits the input "str" into a list of words using space (" ") as a delimiter. It then maps over the list of words, looking up each word in the "dict" dictionary using Map.get(). If the word is found in the dictionary, its corresponding value is returned. Otherwise, the original word is returned.

**Task 10** -- Write a function that receives as input three digits and arranges them in an order that would create the smallest possible number. Numbers cannot start with a 0.

```elixir
  def smallestNumber(a, b, c) do
    list = [a, b, c]
    list = Enum.sort(list)
    if List.first(list) == 0 do
      [Enum.at(list, 1), 0, Enum.at(list, 2)]
    else
      list
    end
  end
```

This function creates a list containing these three values and then sorts the list in ascending order using the Enum.sort function.

If the first element of the sorted list is equal to zero, the function returns a new list with the second element set to zero, otherwise it returns the sorted list.

**Task 11** -- Write a function that would rotate a list n places to the left.

```elixir
  def rotateLeft(list, n) do
    Enum.concat(Enum.drop(list, n), Enum.take(list, n))
  end
```

The function returns a new list that is formed by rotating the original list n positions to the left.

The implementation of the function is achieved using Enum.drop and Enum.take to split the original list into two parts: the first part containing all elements after the first n elements, and the second part containing the first n elements. These two parts are then concatenated together using Enum.concat to create the rotated list.

**Task 12** -- Write a function that lists all tuples a, b, c such that a^2 + b^2 = c^2 and a, b ≤ 20.

```elixir
  def listRightAngleTriangles() do
    for a <- 1..20, b <- 1..20,
        c = round(:math.sqrt(a*a + b*b)),
        c*c == a*a + b*b, do: {a, b, c}
  end
```

The loop iterates over values of a and b from 1 to 20. For each pair of a and b, it calculates the value of c using the Pythagorean theorem (i.e., c = sqrt(a*a + b*b)), rounds the result to the nearest integer, and checks if c satisfies the Pythagorean theorem (i.e., c*c == a*a + b*b).

If c is an integer and satisfies the Pythagorean theorem, the loop returns a tuple containing the values of a, b, and c. The resulting list contains all the tuples for which the Pythagorean theorem holds true, and thus represents all the right-angled triangles with integer side lengths that have a side length no greater than 20.

**Task 13** -- Write a function that eliminates consecutive duplicates in a list.

```elixir
  def removeConsecutiveDuplicates(list) do
    list
    |> Enum.reduce([], fn x, acc ->
       if acc == [] || List.first(acc) != x do
        [x | acc] else acc end end)
    |> Enum.reverse
  end
```

The function uses Enum.reduce to iterate through each element of the list, building up a new list acc as it goes.

If the current element x is different from the first element of acc (or acc is empty), then the current element is added to the list acc. Otherwise, the current element is skipped.

Finally, the resulting list acc is reversed and returned as the output of the function, with all consecutive duplicate elements removed.

**Task 14** -- Write a function that, given an array of strings, will return the words that can
be typed using only one row of the letters on an English keyboard layout.

```elixir
  def lineWords(list) do
    rows = ["qwertyuiop", "asdfghjkl", "zxcvbnm"]

    list
    |> Enum.filter(fn x -> Enum.any?(rows, fn row ->
      x
      |> String.downcase()
      |> String.graphemes()
      |> Enum.all?(fn x -> String.contains?(row, x) end) end)
    end)
  end
```

It creates a list of three strings representing rows of keys on a QWERTY keyboard.

The code then filters the input list by selecting only the words that can be typed using the same row of keys on the keyboard. It does this by converting each word to lowercase, breaking it into individual graphemes (letters), and checking if all of the graphemes are contained within one of the three rows of keys. The filtered list of words is then returned as the output of the function.

**Task 15** -- Create a pair of functions to encode and decode strings using the Caesar cipher.

```elixir
  def encode(word, shift) do
    list = String.to_charlist(word)
    ciphertext = Enum.map(list, fn x -> x + shift end)
    List.to_string(ciphertext)
  end

  def decode(word, shift) do
    list = String.to_charlist(word)
    plaintext = Enum.map(list, fn x -> x - shift end)
    List.to_string(plaintext)
  end
```

The encode function takes a word (a string) and a shift (an integer) as input. It first converts the word into a list of characters, then shifts each character in the list by shift positions in the ASCII table, and finally converts the resulting list of shifted characters back into a string. The result is the encrypted version of the input word.

The decode function takes an encrypted word and a shift as input. It performs the reverse operation of the encode function by shifting each character in the word backwards by shift positions in the ASCII table to recover the original plaintext version of the input word.

**Task 16** -- White a function that, given a string of digits from 2 to 9, would return all
possible letter combinations that the number could represent (think phones with buttons).

```elixir
  def lettersCombinations(digits) do
    digits
    |> String.graphemes()
    |> Enum.map(fn digit ->
      case digit do
        "2" -> ["a", "b", "c"]
        "3" -> ["d", "e", "f"]
        "4" -> ["g", "h", "i"]
        "5" -> ["j", "k", "l"]
        "6" -> ["m", "n", "o"]
        "7" -> ["p", "q", "r", "s"]
        "8" -> ["t", "u", "v"]
        "9" -> ["w", "x", "y", "z"]
        _ -> []
      end
    end)
    |> Enum.reduce([""], fn list1, list2 ->
      list2
      |> Enum.flat_map(fn x -> Enum.map(list1, fn y -> x <> y end) end)
    end)
  end
```

It takes a string digits as input. The function then processes the string by first breaking it down into individual graphemes (i.e., individual characters, including any diacritical marks), and then mapping each digit to a corresponding list of letters. For example, the digit "2" maps to the list ["a", "b", "c"].

Finally, the function generates all possible combinations of these letters, and returns them as a list of strings. The output is obtained by starting with the empty string and iteratively appending each letter from each list to every string in the previous list of combinations.

**Task 17** -- White a function that, given an array of strings, would group the anagrams together.

```elixir
def groupAnagrams(list) do
  list
  |> Enum.group_by(fn element ->
  String.split(String.downcase(element), "")
  |> Enum.sort()
  |> List.to_string end)
  |> Enum.map(fn {key, values} -> {key, Enum.map(values, fn x -> x end)} end)
end
```

The function first groups the elements in the list by converting each element to lowercase, splitting it into individual characters, sorting them alphabetically, and converting the result back to a string. Then, it maps each group of anagrams to a tuple containing the sorted key and a list of the original values in that group. The resulting output is a list of tuples representing each group of anagrams in the original list.

**Task 18** -- Write a function to find the longest common prefix string amongst a list of
strings.

```elixir
def common_prefix(list) do

  min = Enum.min(list)
  length = String.length(min)

  Enum.reduce(0..length-1, "", fn i, acc -> chars = Enum.map(list, fn s -> String.at(s, i) end)
    if Enum.uniq(chars) == [Enum.at(chars, 0)] do
      acc <> String.slice(Enum.at(chars, 0), 0, 1)
    else
      acc
    end
  end)
end
```

The function finds the common prefix among the strings in the list and returns it as a string.

To find the common prefix, the function first finds the minimum string in the list, and then gets the length of that string. It then uses the Enum.reduce function to iterate over a range of indices from 0 to length-1.

For each index i, the function maps over the list of strings to extract the character at that index using the String.at function. It then checks if all the characters at that index are the same using the Enum.uniq function.

If all the characters are the same, the function appends the character to an accumulator string using the String.slice and <> operators. If not, it returns the accumulator string unchanged.

Finally, the function returns the accumulated string as the common prefix among the strings in the input list.

**Task 19** -- Write a function to convert arabic numbers to roman numerals.

```elixir
def to_roman(0), do: ""
def to_roman(nr), do: to_roman(nr, [
  {1000, "M"},
  {900, "CM"},
  {500, "D"},
  {400, "CD"},
  {100, "C"},
  {90, "XC"},
  {50, "L"},
  {40, "XL"},
  {10, "X"},
  {9, "IX"},
  {5, "V"},
  {4, "IV"},
  {1, "I"}
])


defp to_roman(nr, symbols) do
  case symbols do
    [] -> ""
    [{value, symbol}] when nr >= value -> symbol <> to_roman(nr - value, symbols)
    [_ | rest] -> to_roman(nr, rest)
  end
end

```

The function uses a list of tuples to represent the Roman numeral symbols and their corresponding values.

The first line of the function defines a pattern match for when the input nr is zero, returning an empty string.

The second line defines the main implementation of the function using a private function to_roman/2 that takes an integer and a list of tuples as input. The function recursively matches the list of tuples against the input integer until it finds the largest symbol that is less than or equal to the input integer. It then appends the corresponding symbol to the result string and calls itself with the remaining value and the list of tuples without the used symbol.

If the list of tuples is empty and the input integer is still greater than zero, the function returns an empty string.

**Task 20** -- Write a function to calculate the prime factorization of an integer.

```elixir
def factors_of(n, divisor \\ 2) do
  if n <= 2 do
    [n]
  else
    if rem(n, divisor) == 0 do
      [divisor | factors_of(div(n, divisor), divisor)]
    else
      factors_of(n, divisor + 1)
    end
  end
end

def factorize(n) do
  result = factors_of(n) |>  Enum.filter(&(WEEK2.isPrime/1))
  Enum.map(result, &to_string/1)
end

```

The factors_of function takes in an integer n and a default parameter divisor of 2. It checks if n is less than or equal to 2. If so, it returns a list containing n. Otherwise, it checks if divisor is a factor of n. If it is, it returns a list containing divisor and recursively calls itself with n divided by divisor and divisor as the arguments. If divisor is not a factor of n, it recursively calls itself with n and divisor + 1 as the arguments.

The factorize function takes in an integer n. It calls factors_of with n as the argument, filters the resulting list of factors using the isPrime function from a module called WEEK2, and then maps the filtered list to a list of strings using the to_string function.

## P0W3

**Task 1** -- Create an actor that prints on the screen any message it receives.

```elixir
defmodule Print do
  def start do
    spawn(__MODULE__, :loop, [])
  end

  def loop do
    receive do
      {message} ->
        IO.puts(message)
        loop()
    end
  end
end
```

It has two functions:
start(): This function creates a new process (using spawn) and runs the loop() function in that process.
loop() function waits for a message to be received, and when a message is received it prints the message to the console using IO.puts(). Then it calls itself recursively to wait for the next message.

**Task 2** -- Create an actor that returns any message it receives, while modifying it.

```elixir
defmodule Modifier do
  def start do
    spawn(__MODULE__, :loop, [])
  end

  def loop do
    receive do
      message ->
        case message do
          integer when is_integer(message) ->
            IO.puts "Received: #{integer}."
            loop()
          bitstring when is_bitstring(message) ->
            IO.puts "Received: #{bitstring}."
            loop()
          _ ->
            IO.puts "Received: I don’t know how to HANDLE this!"
            loop()
        end
    end
  end
end

# pid = Modifier.start
# spawn fn -> send(pid, 10) end | to avoid printing input
```

The "start" function creates a new process using the "spawn" function, which starts a new process that executes the "loop" function in the current module (MODULE).

The "loop" function continuously waits for incoming messages using the "receive" block. Once a message is received, it checks if the message is an integer or a bitstring using the "is_integer" and "is_bitstring" functions respectively. If the message is an integer or a bitstring, it prints out a message indicating what type of message it received. If the message is anything else, it prints a generic message indicating that it doesn't know how to handle the message. Finally, the "loop" function calls itself recursively to wait for the next message.

**Task 3** -- Create a two actors, actor one ”monitoring” the other. If the second actor stops, actor one gets notified via a message.

```elixir
defmodule Monitor do
  def start do
    spawn(__MODULE__, :loop, [])
  end

  def loop do
    receive do
      {:monitoring, pid} ->
        Process.monitor(pid)
        loop()

      {:DOWN, _ref, :process, _obj, reason} ->
        IO.puts("The monitored actor stopped, due to #{reason}.")
    end
  end
end

# monitoring_pid = Monitor.start
# monitored_pid = Print.start
# send(monitoring_pid, {:monitoring, monitored_pid})
# Process.exit(monitored_pid, :kill)
```

Explanations of the functions:
start: This function starts a new process by invoking spawn with the loop function as an argument. The loop function is a recursive function that waits to receive messages. If the message received is {:monitoring, pid}, the function calls Process.monitor(pid) to monitor the process identified by pid. If the message received is {:DOWN, _ref, :process,_obj, reason}, the function prints a message to the console indicating that the monitored actor has stopped due to reason.

loop: This function waits to receive messages using the receive keyword. It handles two types of messages: {:monitoring, pid} and {:DOWN,_ref, :process,_obj, reason}.

**Task 4** -- Create an actor which receives numbers and with each request prints out the
current average.

```elixir
defmodule Average do
  def start do
    spawn(__MODULE__, :loop, [0, 1])
  end

  def loop(sum, count) do
    average = sum / count
    IO.puts("Current average is #{average}.")

    receive do
      number ->
        new_sum = sum + number
        new_count = count + 1
        loop(new_sum, new_count)
    end
  end
end

# pid = Average.start
# spawn fn -> send(pid, 10) end | to avoid printing the input
```

The start function spawns a new process that calls the loop function with an initial sum of 0 and count of 1.

The loop function receives messages containing numbers and updates the sum and count variables accordingly. It then calculates the new average and prints it to the console using IO.puts.

**Task 5** -- Create an actor which maintains a simple FIFO queue. You should write helper functions to create an API for the user, which hides how the queue is implemented.

```elixir
defmodule Queue do

  def start() do
    GenServer.start(__MODULE__, [])
  end

  def init(args) do
    Server.init(args)
  end

  def push(pid, item) do
    GenServer.call(pid, {:push, item})
  end

  def pop(pid) do
    GenServer.call(pid, :pop)
  end

  def handle_call(request, from, state) do
    Server.handle_call(request, from, state)
  end
end

defmodule Server do
  use GenServer

  def init(args) do
    {:ok, args}
  end

  def handle_call({:push, item}, _from, queue) do
    {:reply, :ok, [item | queue]}
  end

  def handle_call(:pop, _from, []) do
    {:reply, nil, []}
  end

  def handle_call(:pop, _from, [item | rest]) do
    {:reply, item, rest}
  end
end

# {:ok, pid} = GenServer.start(Queue, [])
# Queue.push(pid,42)
# Queue.pop(pid)
```

It defines two modules, Queue and Server, which work together to create a basic FIFO queue using Elixir's GenServer behavior.

The Queue module provides three functions for interacting with the queue: start/0, which starts a new GenServer process for the queue; push/2, which adds an item to the end of the queue; and pop/1, which removes and returns the first item in the queue.

The Server module defines the behavior of the GenServer process for the queue. Its init/1 function is called when a new process is started and simply returns the initial state (an empty list). Its handle_call/3 function handles requests from the Queue module and updates the queue state accordingly. When the queue is popped, it returns the first item in the list and updates the state to remove that item.

**Task 6** -- Create a module that would implement a semaphore.

```elixir
defmodule Semaphore do
  def create(value) do
    GenServer.start(__MODULE__, value)
  end

  def init(args) do
    SemaphoreServer.init(args)
  end

  def acquire(semaphore_pid) do
    GenServer.call(semaphore_pid, :acquire)
  end

  def release(semaphore_pid) do
    GenServer.call(semaphore_pid, :release)
  end

  def handle_call(request, from, state) do
    SemaphoreServer.handle_call(request, from, state)
  end
end

defmodule SemaphoreServer do
  use GenServer

  def init(value) do
    {:ok, {value, value}}
  end

  def handle_call(:acquire, _from, {count, available}) do
    if available >= 0 do
      {:reply, :acquired, {count, available - 1}}
    else
      {:reply, :error, {count, available}}
    end
  end

  def handle_call(:release, _from, {count, available}) do
    if available < count do
      {:reply, :released, {count, available + 1}}
    else
      {:reply, :error, {count, available}}
    end
  end
end

# {:ok, mutex} = Semaphore.create(0)
# Semaphore.acquire(mutex)
# Semaphore.release(mutex)
```

The Semaphore module uses a GenServer, which is a process that can store state and handle messages sent to it. The SemaphoreServer module defines the behavior of the GenServer, which includes initializing the state of the semaphore and handling requests to acquire or release the semaphore.

The create function initializes a new semaphore with a specified value. The acquire function attempts to acquire the semaphore, blocking the caller until the semaphore is available. The release function releases the semaphore, allowing another process to acquire it.

The handle_call function in the SemaphoreServer module handles the messages sent to the GenServer. In this case, it handles requests to acquire or release the semaphore by updating the state of the semaphore and sending a reply message to the caller.

**Task 7** -- Create a module that would perform some risky business. Start by creating a scheduler actor. When receiving a task to do, it will create a worker node that will perform the
task. Given the nature of the task, the worker node is prone to crashes (task completion rate 50%). If the scheduler detects a crash, it will log it and restart the worker node. If the worker
node finishes successfully, it should print the result.

```elixir
defmodule Scheduler do
  use GenServer

  def start do
    GenServer.start(__MODULE__, :start_worker, name: :worker)
  end

  def init(args) do
    {:ok, args}
  end

  def handle_info(task, state) do
    result = perform_task(task)

    if result == :success do
      IO.puts("Task successful: Miau")
      {:noreply, state}
    else
      IO.puts("Task failed")
      restart_worker()
      {:noreply, state}
    end
  end

  defp perform_task(_task) do
    if Enum.random(0..1) == 1 do
      :success
    else
      :fail
    end
  end

  def restart_worker do
    Process.sleep(3)
    GenServer.cast(__MODULE__, :restart)
    start_worker()
    IO.puts("Restart the worker...")
  end

  def start_worker do
    spawn(__MODULE__, :loop, [])
  end

  def loop do
    receive do
      {task} ->
        perform_task(task)
        loop()
    end
  end
end

# Scheduler.start
# send(Worker, "hi")
```

Explanations of the functions:

The start function starts a new GenServer process with :start_worker as an argument and assigns it the name :worker.

The init function initializes the state of the GenServer process with the given arguments.

The handle_info function receives a message (a task) and performs the perform_task function on it. If perform_task returns :success, it prints "Task successful: Miau" to the console and returns {:noreply, state}. Otherwise, it prints "Task failed", calls restart_worker function, and returns {:noreply, state}.

The perform_task function randomly returns either :success or :fail.

The restart_worker function puts the current process to sleep for 3 seconds, sends a :restart message to itself, starts a new worker with start_worker function, and prints "Restart the worker..." to the console.

The start_worker function spawns a new process with the loop function.

The loop function waits for a message and performs the perform_task function on it. It then calls loop function again to wait for the next message.

**Task 8** -- Create a module that would implement a doubly linked list where each node of
the list is an actor.

```elixir
defmodule DLList do

  def create_dllist(elements) do
    start_node = spawn_nodes(elements, nil)
    %{start_node: start_node}
  end

  def spawn_nodes([], _left_node) do
    nil
  end

  def spawn_nodes([first | rest], left_node) do
    current_node = spawn(fn -> handle_list(first, left_node, nil) end)
    next_node = spawn_nodes(rest, current_node)
    send(current_node, {:update_right, next_node})
    current_node
  end

  def handle_list(current_node, left_node, right_node) do
    receive do
      {:update_right, new_right_node} ->
        handle_list(current_node, left_node, new_right_node)

      {:traverse, node_pid, list} ->
        if right_node == nil, do: send(node_pid, {list ++ [current_node]}),
        else: send(right_node, {:traverse, node_pid, list ++ [current_node]})

      {:inverse, node_pid, list} ->
        if right_node == nil, do: send(node_pid, {[current_node | list]}),
        else: send(right_node, {:inverse, node_pid, [current_node | list]})
    end
    handle_list(current_node, left_node, right_node)
  end

  def traverse(list) do
    start_node_pid = list.start_node
    send(start_node_pid, {:traverse, self(), []})

    receive do
      element ->
        element
    end
  end

  def inverse(list) do
    start_node_pid = list.start_node
    send(start_node_pid, {:inverse, self(), []})

    receive do
      element ->
        element
    end
  end
end

# list = DLList.create_dllist([1,2,3])
# DLList.traverse(list)
# DLList.inverse(list)
```

The "create_dllist" function takes a list of elements and creates a new doubly-linked list. The list is constructed using the "spawn_nodes" function, which recursively spawns new processes to represent each element in the list. Each node process communicates with its neighbors using messages to maintain the links between nodes.

The "handle_list" function is the main message handling function for each node. It responds to two types of messages: "traverse" and "inverse". The "traverse" message is used to traverse the list and return its elements, while the "inverse" message is used to return the elements in reverse order.

The "traverse" and "inverse" functions are used to initiate traversal and inversion of the list, respectively. They send messages to the first node in the list to start the process, and then wait for the results using the "receive" construct.

## P0W4

**Task 1** -- Create a supervised pool of identical worker actors. The number of actors is static, given at initialization. Workers should be individually addressable. Worker actors should echo any message they receive. If an actor dies (by receiving a “kill” message), it should
be restarted by the supervisor. Logging is welcome.

```elixir
defmodule Worker do
  use GenServer

  def start_link(id) do
    GenServer.start_link(__MODULE__, [id], name: {:global, :"worker_#{id}"})
  end

  def init([id]) do
    IO.puts("Worker #{inspect(id)} started.")
    {:ok, id}
  end

  def handle_info(:kill, id) do
    IO.puts("Worker #{inspect(id)} is killed.")
    {:stop, :killed, id}
  end

  def handle_info(message, id) do
    IO.puts("Worker #{inspect(id)} says: #{inspect(message)}.")
    {:noreply, id}
  end
end

defmodule WorkerSupervisor do
  use Supervisor

  def start_link(nr_workers) do
    Supervisor.start_link(__MODULE__, nr_workers, name: __MODULE__)
  end

  def init(nr_workers) do
    children = for id <- 1..nr_workers do
      %{
        id: id,
        start: {Worker, :start_link, [id]}
      }
    end
    Supervisor.init(children, strategy: :one_for_one)
  end

  def get_worker(id) do
    {_, worker_pid, _, _} =
      List.keyfind(
        Supervisor.which_children(__MODULE__), id, 0, fn {worker_id, _, _, _}, id -> worker_id == id end)
    worker_pid
  end

end

# WorkerSupervisor.start_link(3)
# worker = WorkerSupervisor.get_worker(2)
# send(worker, "hello worker 2")
# send(worker, :kill)
```

The Worker module defines a GenServer that can be started with a unique ID using start_link/1. When started, it prints a message to the console indicating that it has started. It then waits for messages to be sent to it. If it receives the :kill message, it prints a message indicating that it has been killed and stops. Otherwise, it simply prints the message it received.

The WorkerSupervisor module defines a supervisor that can be started with a specified number of workers using start_link/1. When started, it initializes a list of child processes with unique IDs and the start_link/1 function from the Worker module. It uses the one-for-one strategy to manage these workers. The get_worker/1 function can be used to retrieve the process ID of a specified worker.

The code can be used to start a supervisor with a specified number of worker processes, retrieve the process ID of a specified worker, and send messages to the worker processes.

**Task 2** -- Create a supervised processing line to clean messy strings. The first worker in the line would split the string by any white spaces (similar to Python’s str.split method). The second actor will lowercase all words and swap all m’s and n’s (you nomster!). The third
actor will join back the sentence with one space between words (similar to Python’s str.join method). Each worker will receive as input the previous actor’s output, the last actor printing the result on screen. If any of the workers die because it encounters an error, the whole processing line needs to be restarted. Logging is welcome.

```elixir
defmodule StringCleaner do
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = [
      FirstWorker,
      SecondWorker,
      ThirdWorker
    ]
    |> Enum.map(&worker_spec(&1))

    Supervisor.init(children, strategy: :one_for_all)
  end

  def clean(string) do
    [FirstWorker, SecondWorker, ThirdWorker]
    |> Enum.reduce(string, fn worker, str ->
      GenServer.call(worker, str)
    end)
  end

  defp worker_spec(module) do
    %{
      id: module,
      start: {module, :start_link, []}
    }
  end
end

defmodule FirstWorker do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call(string, _from, state) do
    {:reply, String.split(string), state}
  end
end

defmodule SecondWorker do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call(string, _from, state) do
    string = Enum.map(string, fn word ->
      String.downcase(word)
      |> String.replace("n", "_ULALA_")
      |> String.replace("m", "n")
      |> String.replace("_ULALA_", "m")
    end)

    {:reply, string , state}
  end
end

defmodule ThirdWorker do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call(string, _from, state) do

    {:reply, Enum.join(string, " "), state}
  end
end

# StringCleaner.start_link()
# StringCleaner.clean("Messy nu messy doesn't matter. A problem is a problem.")
```

This code defines a module StringCleaner which is a supervisor for three worker processes: FirstWorker, SecondWorker, and ThirdWorker. The StringCleaner module has a clean function which takes a string argument, and passes it through each worker process in turn using GenServer.call. The first worker splits the string into a list of words. The second worker performs some simple string manipulations (lowercasing, replacing 'n' with 'm' and vice versa). The third worker joins the words back together with spaces between them. The final result is the cleaned string returned by the clean function. The code also includes the necessary start_link functions for each module.

**Task 3** -- Write a supervised application that would simulate a sensor system in a car.
There should be sensors for each wheel, the motor, the cabin and the chassis. If any sensor dies
because of a random invalid measurement, it should be restarted. If, however, the main sensor
supervisor system detects multiple crashes, it should deploy the airbags.

```elixir
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
```

When started, the application creates a main supervisor for the sensor system and starts four additional sensor supervisors for the cabin, motor, chassis, and wheels of the car. Each supervisor is responsible for starting and supervising a group of sensors that are used to monitor different parts of the car. The supervisors are designed to restart the sensors if they fail, up to a maximum of two times. The code also provides a kill function that can be used to simulate the failure of a specific sensor by calling its handle_call function and causing it to exit with a reason of :killed.

**Task 4** -- Write an application that, in the context of actor supervision. would mimic the
exchange in that scene from the movie Pulp Fiction.

```elixir
defmodule TheSupervisor do
  def start do
    spawn_link(fn -> talk(1) end)
  end

  defp talk(count) when count <= 1 do
    IO.puts "Actor One: What does Marcellus look like?"
    :timer.sleep(2000)
    IO.puts "Actor Two: What"
    :timer.sleep(1000)

    IO.puts "Actor One: What country you from?!"
    :timer.sleep(1000)
    IO.puts "Actor Two: What"
    :timer.sleep(1000)

    IO.puts "Actor One: What ain't no country I've ever heard of! They speak English in What?"
    :timer.sleep(1000)
    IO.puts "Actor Two: What"
    :timer.sleep(1000)

    IO.puts "Actor One: English mf do you speak it!?"
    :timer.sleep(1000)
    IO.puts "Actor Two: What"
    :timer.sleep(1000)

    IO.puts "Actor One: Describe what Marcellus Wallace looks like."
    :timer.sleep(1000)
    IO.puts "Actor Two: Yes"
    :timer.sleep(1000)

    IO.puts "Actor One: Dose he look like a btch?"
    :timer.sleep(1000)
    IO.puts "Actor Two: He's Black"
    :timer.sleep(1000)

    IO.puts "Actor One: Say what again. SAY WHAT again! And I dare you, I double dare you mf! Say what one more time."
    :timer.sleep(1000)
    IO.puts "Actor Two: What"
    :timer.sleep(1000)

    talk(count + 1)
  end

  defp talk(_count) do
    IO.puts "===BANG==="
    :timer.sleep(1000)
    Process.exit(self(), :kill)
  end
end

defmodule TheVictim do
  def start do
    spawn_link(fn -> talk(1) end)
  end

  defp talk(count) when count <= 7 do
    receive do
      _ ->
        IO.puts "Actor One: What"
        :timer.sleep(1000)
        talk(count + 1)
    end
  end

  defp talk(_count) do
    IO.puts "..."
  end
end

# TheSupervisor.start
# TheVictim.start
```

TheSupervisor.start function spawns a new process and links it to the current process. The linked process executes the talk function, which prints a series of lines from the movie "Pulp Fiction" and waits for a specified time between each print.

TheVictim.start function spawns a new process and links it to the current process. The linked process executes the talk function, which waits to receive a message and then prints a line from the movie "Pulp Fiction" and waits for a specified time before executing the talk function again. The talk function runs 7 times before stopping.

## P0W5

**Task 1** -- Write an application that would visit this link. Print out the HTTP response
status code, response headers and response body.

```elixir
defmodule HTMLResponse do
  require HTTPoison

  @url "https://quotes.toscrape.com/"

  def get_data(url \\ @url) do
    response = HTTPoison.get!(url)
    data = %{
      status_code: response.status_code,
      headers: response.headers,
      body: response.body
    }
    Enum.reverse(data)
  end
end
```

This Elixir code defines a module called HTMLResponse that uses the HTTPoison library to make a GET request to a specified URL (or a default URL if none is provided). The response from the request is then parsed into a map that contains the status code, headers, and body, and the resulting map is returned in reverse order.

**Task 2 & 3** -- Continue your previous application. Extract all quotes from the HTTP
response body. Collect the author of the quote, the quote text and tags. Save the data
into a list of maps, each map representing a single quote.
Continue your previous application. Persist the list of quotes into a file.
Encode the data into JSON format. Name the file quotes.json.

```elixir
defmodule QuoteScraper do
  require HTTPoison
  require Jason

  @url "https://quotes.toscrape.com/"

  def get_quotes(url \\ @url) do
    HTTPoison.get!(url)
    |> Map.fetch!(:body)
    |> Floki.parse_document!()
    |> Floki.find(".quote")
    |> Enum.map(&parse_quote/1)
  end

  defp parse_quote(html) do
    quotes = %{
      quote: Floki.find(html, ".text") |> Floki.text(),
      author: Floki.find(html, ".author") |> Floki.text(),
      tags: Floki.find(html, ".tags a") |> Enum.map(&Floki.text/1)
    }
    quotes
  end

  def to_file do
    json_string = Jason.encode!(get_quotes())
    File.write("./lib/quotes.json", json_string)
  end

end

# QuoteScraper.get_quotes
# QuoteScraper.to_file
```

get_quotes(...) - This function makes a GET request to a URL (defaulting to "https://quotes.toscrape.com/") using the HTTPoison library, extracts the response body using Map.fetch! and parses the HTML using Floki. It then searches for all elements with class "quote" and maps them through the parse_quote/1 function, which extracts the quote text, author, and tags from the HTML and returns them in a map. The function ultimately returns a list of maps, each containing a quote, its author, and associated tags.

to_file() - This function encodes the result of get_quotes() as JSON using the Jason library and writes the JSON to a file located at "./lib/quotes.json".

**Task 4** -- Write an application that would implement a Star Wars-themed RESTful API.
The API should implement the following HTTP methods:
• GET /movies
GET /movies/:id
• POST /movies
• PUT /movies/:id
• PATCH /movies/:id
• DELETE /movies/:id
Use a database to persist your data.

```elixir
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
```

The SWA module is the application's entry point and defines the start function, which is called when the application is started. It starts the Cowboy HTTP server on a given port and initializes the ETS data structure.

The Endpoints module defines the HTTP endpoints that expose the CRUD operations for the movie database. It uses the Plug library to handle HTTP requests and responses. It defines five routes for getting all movies, getting a movie by its ID, creating a movie, updating a movie, and deleting a movie.

The ETS_DataBase module defines a GenServer that manages the movie database using the ETS data structure. It initializes the ETS table with a list of movie maps and provides functions for getting all movies, getting a movie by its ID, creating a movie, updating a movie, and deleting a movie.


## Conclusion

In conclusion, this laboratory work was a valuable experience for familiarizing myself with the Elixir language and the actor model concept. Through completing the tasks, I gained practical knowledge of Elixir's syntax and structure, as well as its unique features such as pattern matching and concurrency through the actor model.

I began by learning about the basic data types in Elixir and practicing how to manipulate them using built-in functions. Then I moved on to exploring functions and modules in Elixir, and learned how to create and use them effectively. Additionally, gaining insights of Elixir's unique pattern matching capabilities and how it can simplify code.

I learned about the actor model, a powerful concept for building highly concurrent and fault-tolerant systems. About processes, the fundamental building blocks of the actor model in Elixir, and how to create and communicate between them using messages. I also practiced using supervision trees to build fault-tolerant systems that can recover from failures.

Overall, this laboratory work provided us with a foundation in Elixir and the actor model, which will be invaluable in future projects involving highly concurrent and fault-tolerant systems.

P.S PTR is like vegetables, I know that it is useful, but I hate it.

## Bibliography

1. <https://elixir-lang.org/docs.html>
2.	<https://hexdocs.pm/elixir/Kernel.html>
3.	<https://hashrocket.com/blog/posts/elixir-for-loops-go-beyond-comprehension>
4.	<https://elixirforum.com/t/function-calling-another-function/39182>
5.	<https://elixirschool.com/en/lessons/basics/pipe_operator>
6.	<https://hexdocs.pm/elixir/1.14/Enumerable.html>
7.	<https://elixir-lang.org/getting-started/pattern-matching.html>
8.	<https://elixir-lang.org/getting-started/mix-otp/genserver.html>
9.	<https://elixirschool.com/en/lessons/intermediate/concurrency#process-linking-2>
10.	<https://elixirschool.com/en/lessons/intermediate/concurrency>
11.	<https://hexdocs.pm/elixir/1.12/Process.html#monitor/1>
12.	<https://hexdocs.pm/elixir/1.14/GenServer.html>
13.	<https://hexdocs.pm/elixir/1.14/GenServer.html>
14.	<https://elixirforum.com/t/how-to-give-genserver-process-a-name/36820/3>
15.	<https://www.tutorialspoint.com/elixir/elixir_processes.htm>
16.	<https://www.cloudbees.com/blog/linking-monitoring-and-supervising-in-elixir>
17.	<https://hexdocs.pm/elixir/Supervisor.html>
18.	<https://hexdocs.pm/elixir/Application.html>
19.	<https://elixir-lang.org/getting-started/mix-otp/ets.html>
20.	<https://elixirschool.com/en/lessons/storage/ets>
21.	<https://elixirschool.com/en/lessons/misc/plug#prerequisites-0>
22.	<https://imhassane.medium.com/build-a-simple-api-with-elixir-plug-mongodb-and-cowboy-ac715dfee987>

