class UserSessionDecorator < ApplicationDecorator
  delegate_all
  
  def error_message_title
    "Unable to login due to the following errors:"
  end
end
