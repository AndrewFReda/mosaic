# Set up routes for sending Paperclip attachments to Amazon S3:

# Use of Picture name in route
Paperclip.interpolates('name') do |attachment, style|
  attachment.instance.name.parameterize
end

# Use of Picture type as a string in route.
# Use 'picture_type' to invoke
Paperclip.interpolates('picture_type') do |attachment, style|
  if not attachment.instance.composition_id.nil?
    "composition-pictures".parameterize
  elsif not attachment.instance.base_id.nil?
    "base-pictures".parameterize
  else
    "mosaics".parameterize    
  end
end

# Use of User's email in route.
Paperclip.interpolates('user_email') do |attachment, style|
  id = attachment.instance.base_id ||
        attachment.instance.mosaic_id || 
          attachment.instance.composition_id 
  User.find(id).email
end