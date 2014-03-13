class PartialDecorator < Draper::Decorator
  include Draper::LazyHelpers

  def initialize(data) 
    data.each do |key, value|
      if value.respond_to? :call
        self.define_singleton_method(key, value) 
      else
        self.define_singleton_method(key, lambda { value })
      end
    end
  end

end
