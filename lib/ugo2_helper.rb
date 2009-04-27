require 'uri'

module Ugo2Helper
  def phpurlencode(str)
    URI.encode(str, /[^a-zA-Z\d\-\_\.]/n)
  end

  def make_ugo2_image_url(server, user, hash, title, ch="UTF-8")
    result =  "http://#{server}/?u=#{user}&h=#{hash}&guid=ON&ut=1"
    result += "&qM=#{phpurlencode(request.referer ? request.referer : '')}|AzR|#{request.port.to_s}|#{phpurlencode(request.request_uri.to_s)}|Y|"
    result += "&ch=#{ch}"
    result += "&sb=#{phpurlencode(title)}"

    return result
  end

  def ugo2_tag(server, user, hash, title, ch="UTF-8")
    image_url = make_ugo2_image_url(server, user, hash, title, ch)
    link_to(
      image_tag(image_url, :border => '0', :size => '72x16', :alt => '携帯アクセス解析'),
      'http://ugo2.jp/m/'
    )
  end
end
