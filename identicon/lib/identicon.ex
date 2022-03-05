defmodule Identicon do
  @moduledoc """
  Documentation for `Identicon`.
  """

  def main(input) do
    input
    |> hash_input()
    |> pick_color()
    |> build_grid()
    |> filter_odd_square()
    |> build_pixel_map()
    |> draw_image()
    |> save_image(input)
  end

  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
          |> :binary.bin_to_list()

    %Identicon.Image{ hex: hex }
  end

  def pick_color(image) do
    %Identicon.Image{ hex: hex_list } = image
    [red, green, blue | _rest ] = hex_list

    %Identicon.Image{ image | color: { red, green, blue }}
  end

  def build_grid(image) do
    %Identicon.Image{ hex: hex_list } = image

    result = hex_list
              |> Enum.chunk_every(3, 3, :discard)
              |> Enum.map(&mirror_row/1)
              |> List.flatten()
              |> Enum.with_index()

    %Identicon.Image{ image | grid: result }
  end

  def mirror_row(row) do
    [first, second | _third ] = row

    row ++ [second, first]
  end

  def filter_odd_square(image) do
    %Identicon.Image{ grid: grid } = image
    grid = Enum.filter grid, fn({ square, _index })  ->
      rem(square, 2) == 0
    end

    %Identicon.Image{ image | grid: grid}
  end

  def build_pixel_map(image) do
    %Identicon.Image{ grid: grid } = image
    pixel_map = Enum.map grid, fn({ _square, index }) ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50

      top_left = { horizontal, vertical }
      bottom_right = { horizontal + 50, vertical + 50}

      { top_left, bottom_right}
    end

    %Identicon.Image{ image | pixel_map: pixel_map }
  end

  def draw_image(image) do
    %Identicon.Image{ color: color, pixel_map: pixel_map } = image

    img = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each pixel_map, fn({ start, stop }) ->
      :egd.filledRectangle(img, start, stop, fill)
    end

    :egd.render(img)
  end

  def save_image(image, input) do
    File.write("#{input}.png", image)
  end
end
