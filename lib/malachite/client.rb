# frozen_string_literal: true

module Malachite
  class Client
    def initialize(name, args)
      @name = name
      @args = args
    end

    def call
      response_from_json(json_function_result)
    end

    def self.method_missing(name, args)
      new(name, args).call
    end

    private

    def json_function_result
      Malachite::Function.new(@name, args_to_json).call
    end

    def args_to_json
      Malachite.dump_json(@args)
    rescue JSON::GeneratorError
      raise Malachite::ArgumentError, "Arguments should be serializable. Try arrays or objects: #{@args.inspect}"
    end

    def response_from_json(response)
      Malachite.load_json(response)
    rescue JSON::ParserError
      raise Malachite::ResponseError, "Go program did not provide a serializable response: #{response.inspect}"
    end
  end
end
