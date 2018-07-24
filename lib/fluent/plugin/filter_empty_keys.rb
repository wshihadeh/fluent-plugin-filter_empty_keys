require 'fluent/filter'
require 'fluent/parser'

module Fluent
  class EmptyKeysFilter < Filter
    Fluent::Plugin.register_filter('empty_keys', self)

    def filter(tag, time, record)
      record.reject{ |k,v| (v.nil? || v.empty?) }
    end
  end
end
