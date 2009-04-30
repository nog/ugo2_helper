require 'test_helper'
gem "actionpack"
require 'action_controller'
require 'action_controller/test_process'
require File.expand_path(File.dirname(__FILE__) + "/../lib/ugo2_helper")

class Ugo2HelperTest < ActiveSupport::TestCase
  include ActionView::Helpers
  include Ugo2Helper

  def setup
    @request ||= ActionController::TestRequest.new
  end

  test "phpurlencode" do
    assert_equal(
      phpurlencode("-_.!~*'();/?:@&=+$,[]"),
      "-_.%21%7E%2A%27%28%29%3B%2F%3F%3A%40%26%3D%2B%24%2C%5B%5D"
    )
  end

  test "ugo2_image_url" do

    request.env["HTTP_REFERER"] = "http://yahoo.co.jp/"

    result = make_ugo2_image_url(
      "b03.ugo2.jp",
      "0000000",
      "aaaaaa",
      "ページのタイトルだよ"
    )

    assert_equal(
      "http://b03.ugo2.jp/?u=0000000&h=aaaaaa&guid=ON&ut=1&qM=http%3A%2F%2Fyahoo.co.jp%2F|AzR|80|test.host|%2F|Y|&ch=UTF-8&sb=%E3%83%9A%E3%83%BC%E3%82%B8%E3%81%AE%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E3%81%A0%E3%82%88",
      result
    )
    assert_match "ut=1", result
    assert_match "ch=UTF-8", result
  end

  test "ugo2_tag" do
    result = ugo2_tag(
      "b03.ugo2.jp",
      "0000000",
      "aaaaaa",
      "ページのタイトルだよ"
    )

    assert_equal result, %Q{<a href="http://ugo2.jp/m/"><img alt="携帯アクセス解析" border="0" height="16" src="http://b03.ugo2.jp/?u=0000000&amp;h=aaaaaa&amp;guid=ON&amp;ut=1&amp;qM=|AzR|80|test.host|%2F|Y|&amp;ch=UTF-8&amp;sb=%E3%83%9A%E3%83%BC%E3%82%B8%E3%81%AE%E3%82%BF%E3%82%A4%E3%83%88%E3%83%AB%E3%81%A0%E3%82%88" width="72" /></a>}
    assert_match "ut=1", result
    assert_match "ch=UTF-8", result
  end


  test "ugo2_tagがut=2だったurlにut=2が渡される" do
    result = ugo2_tag(
      "bxx.ugo2.jp", "0000000", "abcdef", "タイトル",
      :ut => 2
    )
    assert_match "ut=2", result
  end

  test "ugo2_tagがut=2だった時リンクを出力しない" do
    result = ugo2_tag(
      "bxx.ugo2.jp", "0000000", "abcdef", "タイトル",
      :ut => 2
    )

    assert !result.match(/<a /)
  end


  test "make_ugo2_image_urlがut=2だった時ut=2が出力される" do
    result = ugo2_tag(
      "bxx.ugo2.jp", "0000000", "abcdef", "タイトル",
      :ut => 2
    )

    assert !!result.match(%Q{ut=2})
  end

  test "make_ugo2_image_urlがut=2だった時画像のサイズは1x1" do
    result = ugo2_tag(
      "bxx.ugo2.jp", "0000000", "abcdef", "タイトル",
      :ut => 2
    )

    assert !!result.match(%Q{height="1"})
    assert !!result.match(%Q{width="1"})
  end

  def request
    @request
  end
end
