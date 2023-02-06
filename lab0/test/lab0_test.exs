defmodule LAB0Test do
  use ExUnit.Case
  doctest LAB0

  test "PTR greetings" do
    assert LAB0.hello() == "HELLo, PTR!"
  end
end
