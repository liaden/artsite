ActiveAdmin.register User do     
  index do                            
    column :username
    column :email
    column :privilege
    column :current_sign_in_at        
    default_actions                   
  end                                 

  filter :email                       

  form do |f|                         
    f.inputs "Admin Details" do       
      f.input :email                  
      f.input :password               
      f.input :password_confirmation  
    end                               
    f.actions                         
  end                                 
end                                   
