def mock_paperclip_post_process
    Paperclip::Attachment.any_instance.stub(:post_process) do 
    end
end
