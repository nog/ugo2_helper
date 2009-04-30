require 'uri'

module Ugo2Helper
  def phpurlencode(str)
    URI.encode(str, /[^a-zA-Z\d\-\_\.]/n)
  end

  def make_ugo2_image_url(server, user, hash, title, options={})
    options = ugo2_default_options.merge(options)
    ut = options[:ut].to_s
    ch = options[:ch]

    result =  "http://#{server}/?u=#{user}&h=#{hash}&guid=ON&ut=#{ut}"
    result += "&qM=#{phpurlencode(request.referer ? request.referer : '')}|AzR|#{request.port.to_s}|#{phpurlencode(request.host.to_s)}|#{phpurlencode(request.request_uri.to_s)}|Y|"
    result += "&ch=#{ch}"
    result += "&sb=#{phpurlencode(title)}"

    return result
  end

  def ugo2_tag(server, user, hash, title, options={})
    options = ugo2_default_options.merge(options)

    image_url = make_ugo2_image_url(server, user, hash, title, options)

    size = (options[:ut].to_s == "2") ? "1x1" : "72x16"

    link_to_if(
      options[:ut].to_s == "1",
      image_tag(image_url, :border => '0', :size => size, :alt => '携帯アクセス解析'),
      'http://ugo2.jp/m/'
    )
  end

  def ugo2_default_options
    {
      :ut => 1,
      :ch => "UTF-8"
    }
  end
end
