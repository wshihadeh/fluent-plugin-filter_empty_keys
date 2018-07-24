require 'fluent/filter'
require 'fluent/parser'

module Fluent
  class EmptyKeysFilter < Filter
    Fluent::Plugin.register_filter('empty_keys', self)

    def filter(tag, time, record)
      record.reject{ |k,v| (v.nil? || v.to_s.empty?) }
    end
  end
end
