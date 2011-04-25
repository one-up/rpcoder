module RPCoder
  class Type
    attr_accessor :name, :description

    def fields
      @fields ||= []
    end

    def add_field(name, type, options = {})
      fields << Field.new(name, type, options)
    end

    class Field
      attr_accessor :name, :type, :options
      def initialize(name, type, options = {})
        @name = name
        @type = type
        @options = options
      end

      def original_type?
        original_types.include?(@type.to_sym)
      end

      def array?
        @type.to_sym == :Array
      end

      def array_field
        Field.new(name, options[:array_type])
      end

      def original_types
        [:int, :String, :Boolean, :Array]
      end

      def instance_creator(elem = nil, options = {})
        elem = name if elem.nil?
        if original_type?
          "object['#{name}']"
        elsif options[:direct]
          "new #{type}(#{elem})"
        else
          "new #{type}(object['#{elem}'])"
        end
      end
    end
  end
end
