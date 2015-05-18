require 'mini_magick'
require 'pry-byebug'
require 'pry-rails'
require 'benchmark/ips'

=begin

Benchmark.ips do |x|
  # Configure the number of seconds used during
  # the warmup phase (default 2) and calculation phase (default 5)
  x.config(:time => 5, :warmup => 2)

  x.report('mosaic') {
    image = MiniMagick::Image.open('tmp/lol.png')
    convert = MiniMagick::Tool::Convert.new
    100.times do |i|
      convert << '-page' << "+0+#{i * 60}" << image.path
    end
    convert << '-mosaic' << 'tmp/disoneout.png'
    convert.call
  }

  x.report('append') {
    image = MiniMagick::Image.open('tmp/lol.png')
    convert = MiniMagick::Tool::Convert.new
    100.times do |i|
      convert << image.path
    end
    convert << '+append' << 'tmp/distwoout.png'
    convert.call
  }

  x.compare!
end

=end


Benchmark.ips do |x|
  # Configure the number of seconds used during
  # the warmup phase (default 2) and calculation phase (default 5)
  x.config(:time => 5, :warmup => 2)

  x.report('row convert') {
    mosaic_converter = MiniMagick::Tool::Convert.new

    50.times do |i|
      row_converter = MiniMagick::Tool::Convert.new

      50.times do |j|
        row_converter << 'tmp/lol.png'
      end

      row_converter << '+append' << "tmp/distwotemp#{i}.png"
      row_converter.call

      mosaic_converter << "tmp/distwotemp#{i}.png"
    end
    mosaic_converter << '-append' << 'tmp/disisit.png'
    mosaic_converter.call
  }

  x.report('convert') {
    convert = MiniMagick::Tool::Convert.new
    50.times do |i|
      50.times do |j|
        convert << '-page' << "+#{i * 60}+#{j * 60}" << 'tmp/lol.png'
      end
    end
    convert << '-mosaic' << 'tmp/distwoout.png'
    convert.call
  }

  x.report('composite') {
    temp_file = Tempfile.new(['render_composite_image', '.jpg'])
    mosaic = MiniMagick::Image.new(temp_file.path, temp_file)
    # Have to run this command to actually create the files
    mosaic.run_command(:convert, "-size", "#{25 * 60}x#{25 * 60}", "xc:white", mosaic.path)
    image = MiniMagick::Image.open('tmp/lol.png')
    50.times do |i|
      50.times do |j|
        mosaic = mosaic.composite(image) do |comp|
          comp.gravity "NorthWest"
          comp.geometry "+#{i * 60}+#{j * 60}"  
        end
      end
    end

    mosaic.write('tmp/disoneout.png')
  }

  x.compare!
end