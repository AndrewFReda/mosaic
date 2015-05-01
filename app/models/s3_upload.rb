class S3Upload
  include ActiveModel::Model

  def initialize(attrs)
    if attrs[:picture]
      @picture = attrs[:picture]
    end
  end

#  def initialize(picture:)
#    @picture = picture
#  end
  
  def format_return_info
    {
      key:          "#{@picture.user.email}/#{@picture.type}/#{@picture.name}",
      policy:       policy_document(), 
      signature:    signature(),
      content_type: @picture.getContentType(),
      access_key:   ENV['S3_ACCESS_KEY']
    }
  end


  private
    # generate the policy document that amazon is expecting.
    def policy_document
      return @policy if @policy
      
      ret = { 
        expiration: 30.minutes.from_now.utc.strftime('%Y-%m-%dT%H:%M:%S.000Z'),
        conditions: [ 
          { bucket:  ENV['S3_BUCKET'] },
          { acl: "public-read" },
          ["starts-with", "$key", "#{@picture.user.email}/#{@picture.type}/"],
          ["starts-with", "$Content-Type", ""],
          { success_action_status: '201' }
        ]
      }
      @policy = Base64.encode64(ret.to_json).gsub(/\n|\r/, '')
    end

    # sign our request by Base64 encoding the policy document.
    def signature
      Base64.encode64(
        OpenSSL::HMAC.digest(
          OpenSSL::Digest.new('sha1'),
          ENV['S3_SECRET_ACCESS_KEY'],
          policy_document
        )
      ).gsub(/\n/, '')
    end

end