double = fn x -> x * 2 end

result = double.(2)

IO.puts(result)
# 4


# =========================================


Enum.map(1..4, fn i -> i * i end)
# [1, 4, 9, 16]
