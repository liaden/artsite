module Stripe
    class Charge

        def self.use_create_return_value(val)
            run_offline :create

            @create_result = val

        end

        class << self
            alias_method :original_charge, :create
        end
        def self.run_offline f
            new_method_impl = "dummy_#{f}"

            metaclass = class << self; self; end
            metaclass.send :alias_method, f, new_method_impl
        end

        def self.dummy_create(*args)
            @create_result
        end

        def self.run_online f
            method_name = "original_#{f}"

            class << self
                alias_method f, method_name
            end
        end
    end
end

class MockCharge
    def initialize(params)
        params.keys.each do |var|
            self.instance_variable_set "@#{var}", params[var]

            self.define_singleton_method(var) { params[var] }
        end
    end
end

class MockCard
    def initialize(params)
        params.keys.each do |var|
            self.instance_variable_set "@#{var}", params[var]

            self.define_singleton_method(var) { params[var] }
        end
    end
end

