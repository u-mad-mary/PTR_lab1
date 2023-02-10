defmodule WEEK2Test do
  use ExUnit.Case
  doctest WEEK2

  test "PTR greetings" do
    assert WEEK2.hello() == "HELLo, PTR!"
  end
end
