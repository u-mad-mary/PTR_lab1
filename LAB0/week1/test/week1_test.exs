defmodule WEEK1Test do
  use ExUnit.Case
  doctest WEEK1

  test "PTR greetings" do
    assert WEEK1.hello() == "HELLo, PTR!"
  end
end
