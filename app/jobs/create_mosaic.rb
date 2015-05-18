class CreateMosaic < ActiveJob::Base
  queue_as :default

  def perform(attrs)
    binding.pry
    @picture = Picture.find attrs[:id]
    composition_pics = @picture.user.find_pictures_by id: attrs[:composition_picture_ids]
    base_pics        = @picture.user.find_pictures_by id: attrs[:base_picture_id]
    base_pic         = base_pics.first

    mosaic = MosaicCreator.new base_picture: base_pic, composition_pictures: composition_pics
    image  = mosaic.get_image()
    @picture.set_image(image)
    @picture.set_url()
    @picture.save
    image.destroy!
  end
end