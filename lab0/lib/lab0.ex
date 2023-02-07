### P0W1 ###
defmodule LAB0 do

  def hello do
    IO.puts("HELLo, PTR!")
    "HELLo, PTR!"
  end

### P0W2 ###
  # Function that determines whether an input integer is prime.
  def isPrime(n) do
    if n <= 1 do
      false
    else
      Enum.all?(2..(n - 1), fn i -> rem(n, i) != 0 || n == 2 end)
    end
  end

  # Function to calculate the area of a cylinder, given it’s radius and height.
  def cylinderArea(r, h) do
    if (r || h) <= 0 do
      IO.puts("The numbers must be grater than 0.")
    else
          2 * :math.pi * r * (r + h)
    end
  end

  # Function to reverse a list.
  def reverse(list) do
    Enum.reverse(list)
  end

  # Function to calculate the sum of unique elements in a list.
  def uniqueSum(list) do
    list
    |> Enum.uniq()
    |> Enum.sum()
  end

  # Function that extracts a given number of randomly selected elements from a list.
  def extractRandomN(list, n) do
    Enum.take_random(list, n)
  end

  # Function that returns the first n elements of the Fibonacci sequence.
  def fibonacci(0), do: 0
  def fibonacci(1), do: 1
  def fibonacci(n), do: fibonacci(n-1) + fibonacci(n-2)
  def firstFibonacciElements(n) do
    for i <- 1..n do
      fibonacci(i)
    end
  end

  #Function that, given a dictionary, would translate a sentence. Words not found in the dictionary need not be translated.
  def translator(dict, str) do
    list = String.split(str, " ")
    Enum.map(list, fn word -> Map.get(dict, word, word) end)
    |> Enum.join(" ")
  end

  #Function that receives as input three digits and arranges them in an
  #order that would create the smallest possible number. Numbers cannot start with a 0.
  def smallestNumber(a, b, c) do
    list = [a, b, c]
    list = Enum.sort(list)
    if List.first(list) == 0 do
      [Enum.at(list, 1), 0, Enum.at(list, 2)]
    else
      list
    end
  end

  #Function that would rotate a list n places to the left.
  def rotateLeft(list, n) do
    Enum.concat(Enum.drop(list, n), Enum.take(list, n))
  end

  #Function that lists all tuples a, b, c such that a^2 + b^2 = c^2 and a, b ≤ 20.
  def listRightAngleTriangles() do
    for a <- 1..20, b <- 1..20,
        c = round(:math.sqrt(a*a + b*b)),
        c*c == a*a + b*b, do: {a, a, c}
  end

end
