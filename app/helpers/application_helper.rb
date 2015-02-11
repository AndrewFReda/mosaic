module ApplicationHelper

  def picture_lg(picture)
    picture_size(picture, 400)
  end

  def picture_sm(picture)
    picture_size(picture, 80)
  end

  def picture_size(picture, base_dimension)
    puts 'determining size....'
    binding.pry
    image   = Image.read(picture.image).first
    binding.pry
    columns = image.columns
    rows    = image.rows
    x = base_dimension
    y = base_dimension
    if columns > rows
      x *= (columns / rows)
    else
      y *= (rows / columns)
    end
    "#{x}x#{y}"
  end
end
