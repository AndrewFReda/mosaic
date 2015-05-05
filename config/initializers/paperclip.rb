# Set up routes for sending Paperclip attachments to Amazon S3:

# Use of Picture name in route
Paperclip.interpolates('name') do |attachment, style|
  attachment.instance.name
end

# Use of Picture type in route.
Paperclip.interpolates('type') do |attachment, style|
  attachment.instance.type
end

# Use of User's email in route.
Paperclip.interpolates('user_email') do |attachment, style|
  attachment.instance.user.email
end