require_relative "basic_xml"
require 'builder'
require 'test/unit'

class TestBasicXml < Test::Unit::TestCase
	def setup
		@fp_basic = StringIO.new
		@basic_xml = BasicXml.new indent: 2, target: @fp_basic, header: false

		@fp = StringIO.new
		@xml = Builder::XmlMarkup.new indent: 2, target: @fp
	end

	def test_tag
		@basic_xml.foo
		@xml.foo
		assert_equal @fp.string, @fp_basic.string
	end

	def test_content
		@basic_xml.foo "Bar"
		@xml.foo "Bar"
		assert_equal @fp.string, @fp_basic.string
	end

	def test_attributes
		@basic_xml.foo attribute: 'Bar', attribute_1: 'Buzz'
		@xml.foo attribute: 'Bar', attribute_1: 'Buzz'
		assert_equal @fp.string, @fp_basic.string
	end

	def test_content_attributes
		@basic_xml.foo 'Foo', attribute: 'Bar', attribute_1: 'Buzz'
		@xml.foo 'Foo', attribute: 'Bar', attribute_1: 'Buzz'
		assert_equal @fp.string, @fp_basic.string
	end

	def test_indent
		@basic_xml.foo {
			@basic_xml.bar {
				@basic_xml.buzz
			}
		}

		@xml.foo {
			@xml.bar {
				@xml.buzz
			}
		}
		assert_equal @fp.string, @fp_basic.string
	end

	def test_indent_content_attributes
		@basic_xml.foo(attribute: 'Foo'){
			@basic_xml.bar(attribute: 'Bar'){
				@basic_xml.buzz "Content"
				@basic_xml.foobar  "Content" , attribute: 'Foobar'
				@basic_xml.bazbuzz {
					@basic_xml.foo
				}
			}
		}

		@xml.foo(attribute: 'Foo') {
			@xml.bar(attribute: 'Bar'){
				@xml.buzz "Content"
				@xml.foobar  "Content" , attribute: 'Foobar'
				@xml.bazbuzz {
					@xml.foo
				}
			}
		}
		assert_equal @fp.string, @fp_basic.string
	end

	def cleanup
		@fp_basic.reopen("")
		@fp.reopen("")
	end
end