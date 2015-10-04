class SquareJob < ActiveJob::Base
  def perform(data)
    raise NotImplementedError
  end
end
