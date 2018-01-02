module VersionRecord
  module Testing
    module ModelSpawner
      def spawn_model(klass, &block)
        Object.instance_eval { remove_const klass } if Object.const_defined?(klass)
        Object.const_set klass, Class.new(ActiveRecord::Base)
        Object.const_get(klass).class_eval(&block) if block_given?
        @spawned_models << klass.to_sym
      end
    end
  end
end
