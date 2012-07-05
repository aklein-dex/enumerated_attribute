
module EnumeratedAttribute
	module Attribute
		class AttributeDescriptor < Array		
			attr_reader :name
			attr_accessor :init_value
			
			def initialize(name, enums=[], opts={})
				super enums
				@name = name
				@options = opts
				if @options.key?(:localize) && @options[:localize]
					@labels_hash = Hash[*self.collect{|e| [e, e.to_s]}.flatten]
				else
					@labels_hash = Hash[*self.collect{|e| [e, e.to_s.gsub(/_/, ' ').squeeze(' ').capitalize]}.flatten]
				end
			end
			
			def allows_nil?
				@options.key?(:nil) ? @options[:nil] : true
			end
			def allows_value?(value)
				self.include?(value.to_sym)
			end
				
			def enums
				self
			end
			def label(value)
				if @options.key?(:localize) && @options[:localize]
					I18n.t(@labels_hash[value])
				else
					@labels_hash[value]
				end
			end
			def labels
				@labels_array ||= self.map{|e| label(e)}
			end
			def hash
				@labels_hash
			end
			def select_options
				if @options.key?(:localize) && @options[:localize]
					@select_options ||= self.map{|e| [I18n.t(@labels_hash[e]), e.to_s]}
				else
					@select_options ||= self.map{|e| [@labels_hash[e], e.to_s]}
				end
			end
			def set_label(enum_value, label_string)
				reset_labels
				@labels_hash[enum_value.to_sym] = label_string
			end
			
			protected
			def reset_labels
				@labels_array = nil
				@select_options = nil
			end
			
		end
	end
end
