require 'test_helper'
require 'whois/answer/parser/whois.afilias-grs.info.rb'

class AnswerParserWhoisAfiliasGrsInfoTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisAfiliasGrsInfo
    @host   = "whois.afilias-grs.info"
  end

end

class AnswerParserWhoisAfiliasGrsInfoBzTest < AnswerParserWhoisAfiliasGrsInfoTest

  def test_status
    assert_equal  ["CLIENT DELETE PROHIBITED", "CLIENT TRANSFER PROHIBITED", "CLIENT UPDATE PROHIBITED"],
                  @klass.new(load_part('/bz/registered.txt')).status
    assert_equal  [],
                  @klass.new(load_part('/bz/available.txt')).status
  end

  def test_available?
    assert !@klass.new(load_part('/bz/registered.txt')).available?
    assert  @klass.new(load_part('/bz/available.txt')).available?
  end

  def test_registered?
    assert  @klass.new(load_part('/bz/registered.txt')).registered?
    assert !@klass.new(load_part('/bz/available.txt')).registered?
  end


  def test_created_on
    assert_equal  Time.parse("2006-02-12 18:08:52 UTC"),
                  @klass.new(load_part('/bz/registered.txt')).created_on
    assert_equal  nil,
                  @klass.new(load_part('/bz/available.txt')).created_on
  end

  def test_updated_on
    assert_equal  Time.parse("2009-01-21 13:29:10 UTC"),
                  @klass.new(load_part('/bz/registered.txt')).updated_on
    assert_equal  nil,
                  @klass.new(load_part('/bz/available.txt')).updated_on
  end

  def test_expires_on
    assert_equal  Time.parse("2011-02-12 18:08:52 UTC"),
                  @klass.new(load_part('/bz/registered.txt')).expires_on
    assert_equal  nil,
                  @klass.new(load_part('/bz/available.txt')).expires_on
  end

end

class AnswerParserWhoisAfiliasGrsInfoGiTest < AnswerParserWhoisAfiliasGrsInfoTest

  def test_status
    assert_equal  ["OK"],
                  @klass.new(load_part('/gi/registered.txt')).status
    assert_equal  [],
                  @klass.new(load_part('/gi/available.txt')).status
  end

  def test_available?
    assert !@klass.new(load_part('/gi/registered.txt')).available?
    assert  @klass.new(load_part('/gi/available.txt')).available?
  end

  def test_registered?
    assert  @klass.new(load_part('/gi/registered.txt')).registered?
    assert !@klass.new(load_part('/gi/available.txt')).registered?
  end


  def test_created_on
    assert_equal  Time.parse("2004-12-20 13:34:34 UTC"),
                  @klass.new(load_part('/gi/registered.txt')).created_on
    assert_equal  nil,
                  @klass.new(load_part('/gi/available.txt')).created_on
  end

  def test_updated_on
    assert_equal  Time.parse("2008-12-20 19:25:54 UTC"),
                  @klass.new(load_part('/gi/registered.txt')).updated_on
    assert_equal  nil,
                  @klass.new(load_part('/gi/available.txt')).updated_on
  end

  def test_expires_on
    assert_equal  Time.parse("2009-12-20 13:34:34 UTC"),
                  @klass.new(load_part('/gi/registered.txt')).expires_on
    assert_equal  nil,
                  @klass.new(load_part('/gi/available.txt')).expires_on
  end

end

class AnswerParserWhoisAfiliasGrsInfoHnTest < AnswerParserWhoisAfiliasGrsInfoTest

  def test_status
    assert_equal  ["CLIENT DELETE PROHIBITED", "CLIENT TRANSFER PROHIBITED", "CLIENT UPDATE PROHIBITED"],
                  @klass.new(load_part('/hn/registered.txt')).status
    assert_equal  [],
                  @klass.new(load_part('/hn/available.txt')).status
  end

  def test_available?
    assert !@klass.new(load_part('/hn/registered.txt')).available?
    assert  @klass.new(load_part('/hn/available.txt')).available?
  end

  def test_registered?
    assert  @klass.new(load_part('/hn/registered.txt')).registered?
    assert !@klass.new(load_part('/hn/available.txt')).registered?
  end


  def test_created_on
    assert_equal  Time.parse("2003-03-07 05:00:00 UTC"),
                  @klass.new(load_part('/hn/registered.txt')).created_on
    assert_equal  nil,
                  @klass.new(load_part('/hn/available.txt')).created_on
  end

  def test_updated_on
    assert_equal  Time.parse("2009-01-30 16:14:32 UTC"),
                  @klass.new(load_part('/hn/registered.txt')).updated_on
    assert_equal  nil,
                  @klass.new(load_part('/hn/available.txt')).updated_on
  end

  def test_expires_on
    assert_equal  Time.parse("2010-03-07 05:00:00 UTC"),
                  @klass.new(load_part('/hn/registered.txt')).expires_on
    assert_equal  nil,
                  @klass.new(load_part('/hn/available.txt')).expires_on
  end

end

class AnswerParserWhoisAfiliasGrsInfoLcTest < AnswerParserWhoisAfiliasGrsInfoTest

  def test_status
    assert_equal  ["OK"],
                  @klass.new(load_part('/lc/registered.txt')).status
    assert_equal  [],
                  @klass.new(load_part('/lc/available.txt')).status
  end

  def test_available?
    assert !@klass.new(load_part('/lc/registered.txt')).available?
    assert  @klass.new(load_part('/lc/available.txt')).available?
  end

  def test_registered?
    assert  @klass.new(load_part('/lc/registered.txt')).registered?
    assert !@klass.new(load_part('/lc/available.txt')).registered?
  end


  def test_created_on
    assert_equal  Time.parse("2002-12-08 00:00:00 UTC"),
                  @klass.new(load_part('/lc/registered.txt')).created_on
    assert_equal  nil,
                  @klass.new(load_part('/lc/available.txt')).created_on
  end

  def test_updated_on
    assert_equal  Time.parse("2008-12-08 19:25:09 UTC"),
                  @klass.new(load_part('/lc/registered.txt')).updated_on
    assert_equal  nil,
                  @klass.new(load_part('/lc/available.txt')).updated_on
  end

  def test_expires_on
    assert_equal  Time.parse("2009-12-08 00:00:00 UTC"),
                  @klass.new(load_part('/lc/registered.txt')).expires_on
    assert_equal  nil,
                  @klass.new(load_part('/lc/available.txt')).expires_on
  end

end

class AnswerParserWhoisAfiliasGrsInfoMnTest < AnswerParserWhoisAfiliasGrsInfoTest

  def test_status
    assert_equal  ["CLIENT DELETE PROHIBITED", "CLIENT TRANSFER PROHIBITED", "CLIENT UPDATE PROHIBITED"],
                  @klass.new(load_part('/mn/registered.txt')).status
    assert_equal  [],
                  @klass.new(load_part('/mn/available.txt')).status
  end

  def test_available?
    assert !@klass.new(load_part('/mn/registered.txt')).available?
    assert  @klass.new(load_part('/mn/available.txt')).available?
  end

  def test_registered?
    assert  @klass.new(load_part('/mn/registered.txt')).registered?
    assert !@klass.new(load_part('/mn/available.txt')).registered?
  end


  def test_created_on
    assert_equal  Time.parse("2003-04-07 00:00:00 UTC"),
                  @klass.new(load_part('/mn/registered.txt')).created_on
    assert_equal  nil,
                  @klass.new(load_part('/mn/available.txt')).created_on
  end

  def test_updated_on
    assert_equal  Time.parse("2009-04-03 15:50:32 UTC"),
                  @klass.new(load_part('/mn/registered.txt')).updated_on
    assert_equal  nil,
                  @klass.new(load_part('/mn/available.txt')).updated_on
  end

  def test_expires_on
    assert_equal  Time.parse("2010-04-07 00:00:00 UTC"),
                  @klass.new(load_part('/mn/registered.txt')).expires_on
    assert_equal  nil,
                  @klass.new(load_part('/mn/available.txt')).expires_on
  end

end

class AnswerParserWhoisAfiliasGrsInfoScTest < AnswerParserWhoisAfiliasGrsInfoTest

  def test_status
    assert_equal  ["CLIENT DELETE PROHIBITED", "CLIENT TRANSFER PROHIBITED", "CLIENT UPDATE PROHIBITED"],
                  @klass.new(load_part('/sc/registered.txt')).status
    assert_equal  [],
                  @klass.new(load_part('/sc/available.txt')).status
  end

  def test_available?
    assert !@klass.new(load_part('/sc/registered.txt')).available?
    assert  @klass.new(load_part('/sc/available.txt')).available?
  end

  def test_registered?
    assert  @klass.new(load_part('/sc/registered.txt')).registered?
    assert !@klass.new(load_part('/sc/available.txt')).registered?
  end


  def test_created_on
    assert_equal  Time.parse("2004-02-03 19:19:12 UTC"),
                  @klass.new(load_part('/sc/registered.txt')).created_on
    assert_equal  nil,
                  @klass.new(load_part('/sc/available.txt')).created_on
  end

  def test_updated_on
    assert_equal  Time.parse("2009-01-09 21:53:27 UTC"),
                  @klass.new(load_part('/sc/registered.txt')).updated_on
    assert_equal  nil,
                  @klass.new(load_part('/sc/available.txt')).updated_on
  end

  def test_expires_on
    assert_equal  Time.parse("2010-02-03 19:19:12 UTC"),
                  @klass.new(load_part('/sc/registered.txt')).expires_on
    assert_equal  nil,
                  @klass.new(load_part('/sc/available.txt')).expires_on
  end

end

class AnswerParserWhoisAfiliasGrsInfoVcTest < AnswerParserWhoisAfiliasGrsInfoTest

  def test_status
    assert_equal  ["CLIENT DELETE PROHIBITED", "CLIENT TRANSFER PROHIBITED", "CLIENT UPDATE PROHIBITED"],
                  @klass.new(load_part('/vc/registered.txt')).status
    assert_equal  [],
                  @klass.new(load_part('/vc/available.txt')).status
  end

  def test_available?
    assert !@klass.new(load_part('/vc/registered.txt')).available?
    assert  @klass.new(load_part('/vc/available.txt')).available?
  end

  def test_registered?
    assert  @klass.new(load_part('/vc/registered.txt')).registered?
    assert !@klass.new(load_part('/vc/available.txt')).registered?
  end


  def test_created_on
    assert_equal  Time.parse("2005-06-29 00:58:18 UTC"),
                  @klass.new(load_part('/vc/registered.txt')).created_on
    assert_equal  nil,
                  @klass.new(load_part('/vc/available.txt')).created_on
  end

  def test_updated_on
    assert_equal  Time.parse("2009-02-17 17:43:40 UTC"),
                  @klass.new(load_part('/vc/registered.txt')).updated_on
    assert_equal  nil,
                  @klass.new(load_part('/vc/available.txt')).updated_on
  end

  def test_expires_on
    assert_equal  Time.parse("2011-06-29 00:58:18 UTC"),
                  @klass.new(load_part('/vc/registered.txt')).expires_on
    assert_equal  nil,
                  @klass.new(load_part('/vc/available.txt')).expires_on
  end

end
