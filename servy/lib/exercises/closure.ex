defmodule Exercises.Closure do
  def print_number do
    number = 3
    fn -> IO.puts(number) end
  end
end

print_number = Exercises.Closure.print_number()
