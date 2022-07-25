defmodule Exercises.Closure do
  def print_number do
    number = 3
    fn -> IO.puts(number) end
  end
end

print_number = Exercises.Closure.print_number()

IO.inspect(print_number)

print_number.()


# =======================================================================

name = "Allan"

print_name = fn -> IO.puts(name) end

print_name.()

name = "Egidio"

print_name.()

# ========================================================================

say_something = fn (something) -> (fn -> IO.puts(something) end) end
say_dog = say_something.("dog")
say_cat = say_something.("cat")

say_dog.()
say_cat.()
