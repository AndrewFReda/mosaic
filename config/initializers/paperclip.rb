Paperclip.interpolates('name') do |attachment, style|
  attachment.instance.name.parameterize
end

Paperclip.interpolates('picture_type') do |attachment, style|
  if not attachment.instance.composition_id.nil?
    "composition-pictures".parameterize
  elsif not attachment.instance.base_id.nil?
    "base-pictures".parameterize
  else
    "mosaics".parameterize    
  end
end

Paperclip.interpolates('user_email') do |attachment, style|
  id = attachment.instance.base_id ||
        attachment.instance.mosaic_id || 
          attachment.instance.composition_id 
  User.find(id).email
end