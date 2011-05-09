require 'rpcoder/param'

module RPCoder
  class Function
    PARAMS_IN_URL_RE = /:[\w\d]+/
    attr_accessor :name, :description, :path, :method, :return_type

    def params
      @params ||= []
    end

    def return_types
      @return_types ||= []
    end

    def has_return_type?
      !return_types.empty?
    end

    def add_param(name, type, options = {})
      params << Param.new(name, type, options)
    end

    def path_parts
      raise "path must starts with `/`: #{path}" unless path =~ /^\//

      path_strs = path.split(PARAMS_IN_URL_RE)
      params = path.scan(PARAMS_IN_URL_RE)
      parts = []
      ([path_strs.size, params.size].max).times do |variable|
        parts << %Q{"#{path_strs.shift}"}
        parts << params.shift.sub(/^:/, '') rescue nil
      end
      parts
    end

    def query_params
      param_strs = path.scan(PARAMS_IN_URL_RE).map { |i| i.sub(/^:/, '') }
      params.select { |i| !param_strs.include?(i.name.to_s)  }
    end

    def add_return_type(name, type, options = {})
      return_types << Param.new(name, type, options)
    end
  end
end
