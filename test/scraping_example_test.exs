defmodule ScrapingExampleTest do
  use ExUnit.Case
  doctest ScrapingExample

  test "greets the world" do
    assert ScrapingExample.hello() == :world
  end
end
