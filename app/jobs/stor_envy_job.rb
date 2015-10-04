class StorEnvyJob < ActiveJob::Base
  def perform(data)
    raise NotImplementedError
  end
end
