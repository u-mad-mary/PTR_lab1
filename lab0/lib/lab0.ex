### P0W1 ###
defmodule LAB0 do

  def hello do
    IO.puts("HELLo, PTR!")
    "HELLo, PTR!"
  end

### P0W2 ###

  #MINIMAL

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
    Enum.map(1..n, fn i -> fibonacci(i) end)
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
        c*c == a*a + b*b, do: {a, b, c}
  end

  #MAIN

  #Function that eliminates consecutive duplicates in a list.
  def removeConsecutiveDuplicates(list) do
    list
    |> Enum.reduce([], fn x, acc ->
       if acc == [] || List.first(acc) != x do
        [x | acc] else acc end end)
    |> Enum.reverse
  end

  #Function that, given an array of strings, will return the words that can
  #be typed using only one row of the letters on an English keyboard layout.
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

  #A pair of functions to encode and decode strings using the Caesar cipher.
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

  #Function that, given a string of digits from 2 to 9, would return all
  #possible letter combinations that the number could represent (think phones with buttons).
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

#Function that, given an array of strings, would group the anagrams together.
def groupAnagrams(list) do
  list
  |> Enum.group_by(fn element ->
  String.split(String.downcase(element), "")
  |> Enum.sort()
  |> List.to_string end)
  |> Enum.map(fn {key, values} -> {key, Enum.map(values, fn x -> x end)} end)
end

#BONUS

#Function to find the longest common prefix string amongst a list of strings.
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

#Function to convert arabic numbers to roman numerals.
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

#Function that calculates the prime factorization of an integer
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
  result = factors_of(n) |>  Enum.filter(&(LAB0.isPrime/1))
  Enum.map(result, &to_string/1)
end

end
