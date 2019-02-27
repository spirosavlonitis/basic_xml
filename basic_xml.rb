class BasicXml < BasicObject

	def initialize indent:, target:
		@indent = indent
		@cur_indent = 0
		@target = target
	end

	def method_missing tag, *args, &block

		if args.size == 0
			@target.puts "#{' ' * @cur_indent}<#{block ? '' : '/' }#{tag}>"
		elsif args[0].is_a? ::String and block
			::Object.send(:raise, ::ArgumentError, "cannot mix a text argument with a block")
		else
			if args[0].is_a? ::String and args.size == 1
				@target.puts "#{' ' * @cur_indent}<#{tag}>#{args[0]}</#{tag}>"
			elsif args[0].is_a? ::String
				@target.print "#{' ' * @cur_indent}<#{tag} "
				args[1].each do |attrb, value| 
					@target.print %Q[#{attrb}="#{value}"#{' ' unless attrb == args[1].keys.last}]
				end

				@target.puts ">#{args[0]}</#{tag}>"
			end
		end

		if block
			@cur_indent += @indent
			block.call()
			@cur_indent -= @indent
			@target.puts "#{' ' * @cur_indent}</#{tag}>"
		end

	end
end

xml = BasicXml.new indent: 2, target: STDOUT


xml.foo "Matz", language: "Ruby", year: 1992

xml.foo {
	xml.bar {
		xml.buz
		xml.foobar "Name"
	}
}