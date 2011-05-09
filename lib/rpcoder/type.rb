require 'rpcoder/param'

module RPCoder
  class Type
    attr_accessor :name, :description

    def fields
      @fields ||= []
    end

    def add_field(name, type, options = {})
      fields << Field.new(name, type, options)
    end

    class Field < Param
    end
  end
end
