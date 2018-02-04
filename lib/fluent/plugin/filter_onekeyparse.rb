#
# Copyright 2018- tanan
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "fluent/plugin/filter"

module Fluent
  module Plugin
    class OnekeyparseFilter < Fluent::Plugin::Filter
      Fluent::Plugin.register_filter("onekeyparse", self)

      config_param :in_format, :string
      config_param :in_key, :string
      config_param :out_record_keys, :string
      config_param :out_record_types, :string

      def configure(conf)
        super
        @reg = Regexp.new(conf['in_format'], Regexp::IGNORECASE)
      end

      def filter(tag, time, record)
        m = @reg.match(record[@in_key])
        unless m
          nil
          return
        end

        hash = m.named_captures
        record = {}
        @out_record_keys.split(",").each do | key |
          record[key] = hash.has_key?(key) ?  hash[key] : nil
        end
        record
      end

      def filter_stream(tag, es)
        new_es = MultiEventStream.new
        es.each { |time, record|
          begin
            filtered_record = filter(tag, time, record)
            new_es.add(time, filtered_record) if filtered_record
          rescue => e
            router.emit_error_event(tag, time, record, e)
          end
        }
        new_es
      end
    end
  end
end
