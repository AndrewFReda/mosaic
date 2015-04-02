module ApplicationHelper

  def picture_lg(picture)
    picture_size(picture, 400)
  end

  def picture_sm(picture)
    picture_size(picture, 80)
  end

  def picture_size(picture, base_dimension)
    puts 'determining size....'
    image   = Image.read(picture.image).first
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

  def fill_hash_by_hue(comp_pics)
    hash = Hash.new{ [] }
    comp_pics.each do |comp_pic|
      hue = comp_pic.histogram.dominant_hue
      hash[hue] = hash[hue].push(comp_pic)
    end
    hash
  end
end
