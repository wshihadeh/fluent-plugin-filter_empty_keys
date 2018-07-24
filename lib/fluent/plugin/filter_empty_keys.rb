require 'fluent/filter'
require 'fluent/parser'

module Fluent
  class EmptyKeysFilter < Filter
    Fluent::Plugin.register_filter('empty_keys', self)

    config_param :empty_keys, :string, default: nil
    config_param :keys_delimiter, :string, default: ','
    config_param :values_delimiter, :string, default: ':'

    def configure(conf)
        super

        @keys_empty_values = nil
        @keys_empty_values = parse_empty_values_parameter unless @empty_keys.nil?
    end

    def filter(tag, time, record)
      record.reject{ |k,v| (v.nil? || v.to_s.empty? || (!@keys_empty_values.nil? && v.to_s.eql?(@keys_empty_values[k]))) }
    end

    private

    def parse_empty_values_parameter
      keys_empty_values = {}

      @empty_keys.split(@keys_delimiter).each do |pattern_name|
        key, empty_value, format = pattern_name.split(@values_delimiter, 3)
        raise ConfigError, "EmptyValue is needed" if empty_value.nil?
        keys_empty_values[key] = empty_value
      end

      keys_empty_values
    end
  end
end
