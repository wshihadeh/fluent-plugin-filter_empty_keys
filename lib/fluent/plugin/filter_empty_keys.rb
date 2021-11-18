require 'fluent/filter'
require 'fluent/parser'

module Fluent
  class EmptyKeysFilter < Filter
    Fluent::Plugin.register_filter('empty_keys', self)

    config_param :empty_values, :string, default: nil
    config_param :empty_keys, :string, default: nil
    config_param :empty_keys_delimiter, :string, default: ','
    config_param :empty_values_delimiter, :string, default: ','
    config_param :empty_keys_value_delimiter, :string, default: ':'

    def configure(conf)
      super
      @all_empty_values = parse_empty_values_parameter
      @keys_empty_values = nil
      @keys_empty_values = parse_empty_keys_parameter unless @empty_keys.nil?
    end

    def filter(_tag, _time, record)
      record.reject do |k, v|
        (
          v.nil? ||
          v.to_s.empty? ||
          @all_empty_values.include?(v.to_s) ||
          (!@keys_empty_values.nil? && v.to_s.eql?(@keys_empty_values[k]))
        )
      end
    end

    private

    def parse_empty_keys_parameter
      keys_empty_values = {}

      @empty_keys.split(@empty_keys_delimiter).each do |pattern_name|
        key, empty_value, _format = pattern_name.split(@empty_keys_value_delimiter, 3)
        raise ConfigError, 'EmptyValue is needed' if empty_value.nil?

        keys_empty_values[key] = empty_value
      end

      keys_empty_values
    end

    def parse_empty_values_parameter
      if @empty_values.nil?
        []
      else
        @empty_values.split(@empty_values_delimiter)
      end
    end

  end
end
