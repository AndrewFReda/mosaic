module Uploadr
  extend ActiveSupport::Concern

  # UPLOAD HELPERS
  def upload_mosaic(mosaic)
    @user = current_user
    name  = "#{DateTime.now.to_s}-mosaic.jpg"
    path  = "public/images/#{name}"
    
    mosaic.write(path)
    file     = File.open(path)
    @picture = Picture.new(name: name, image: file, mosaic_id: @user.id)
    file.close

    if @picture.save
      @user.mosaics << @picture
      return @user.mosaics.last.id
    else
      @picture.destroy
      raise "Problems occured while saving the mosaic picture."
    end
  end

end