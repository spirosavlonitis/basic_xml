class BasicXml < BasicObject

	def initialize indent:, target:
		@indent = indent
		@cur_indent = 0
		@target = target
	end

	def method_missing tag, *args, &block

		if args.size == 0			# only a tag close if no block is given
			@target.puts "#{' ' * @cur_indent}<#{block ? '' : '/' }#{tag}>"
		elsif args[0].is_a? ::String and block		# malformed xml tag
			::Object.send(:raise, ::ArgumentError, "Cannot mix a text argument with a block")
		elsif args[0].is_a? ::String  # tag content with or without attributes
				@target.print "#{' ' * @cur_indent}<#{tag} "
				if args.size == 2	  # with attributes
					args[1].each do |attrb, value|
						@target.print %Q[#{attrb}="#{value}"#{' ' unless attrb == args[1].keys.last}]
					end
				end
				@target.puts ">#{args[0]}</#{tag}>"
		else
			@target.print "#{' ' * @cur_indent}<#{tag} "
			args[0].each do |attrb, value| 
				@target.print %Q[#{attrb}="#{value}"#{' ' unless attrb == args[0].keys.last}]
			end
			@target.puts  block ? ">" : "/>"
		end

		if block				
			@cur_indent += @indent 			# add indentation before calling the block
			block.call
			@cur_indent -= @indent 			# remove indentation after call to block
			@target.puts "#{' ' * @cur_indent}</#{tag}>"
		end
	end
end

xml = BasicXml.new indent: 2, target: STDOUT

xml.foo "Matz", language: "Ruby", year: 1992
xml.buz coder: "John Doe"

xml.foo(language: "Ruby", year: 1996) {
	xml.bar
}

xml.foo {
	xml.bar {
		xml.buz(coder: "John Doe") { xml.foobarbuzz "Name", dude: 'Hey' }
		xml.foobar "Name"
	}
}
