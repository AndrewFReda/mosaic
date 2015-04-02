module Uploadr
  extend ActiveSupport::Concern
  #TODO: Upload only .jpg or .png

  # UPLOAD HELPERS
  def upload_composition
    @user = current_user
    temps = params[:user][:compositions]

    # Check that temps is not nil before iterating
    temps and temps.each do |temp|

      name     = "#{DateTime.now.to_s}-#{temp.original_filename}"
      file     = File.open(temp.tempfile)
      @picture = Picture.new(name: name, image: file, composition_id: @user.id)
      # TODO: Consider moving this into Picture's initialize or save method
      @picture.set_histogram_from_file(file)
      file.close

      if @picture.save
        @user.composition_pictures << @picture
      else
        @picture.destroy
        raise "Problems occured while uploading a composition picture."
      end
    end
  end

  def upload_base
    @user = current_user
    temps = params[:user][:bases]
    
    # Check that temps is not nil before iterating
    temps and temps.each do |temp|

      name     = "#{DateTime.now.to_s}-#{temp.original_filename}"
      file     = File.open(temp.tempfile)
      @picture = Picture.new(name: name, image: file, base_id: @user.id)
      file.close

      if @picture.save
        @user.base_pictures << @picture
      else
        @picture.destroy
        raise 'Problems occured while uploading a base picture.'
      end
    end
  end

  def upload_mosaic(mosaic)
    @user = current_user
    name  = "#{DateTime.now.to_s}-mosaic.jpg"
    # NOT SURE WHERE TO WRITE TO JUST YET...
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