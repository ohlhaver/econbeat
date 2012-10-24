ActiveAdmin.register Action do
  
index do
    
    column :id
    column :action_type
    column :subject_type
    column :object_type

    column "Title" do |action|
      link_to action.article.title, action.article.url if action.article
    end
    column "Catcher" do |action|
      action.catcher.name if action.catcher
    end

    column :created_at

    default_actions

end





end
