ActiveAdmin.register Author do

filter :name
filter :economist, :as => :check_boxes

  index do
    column :id
    column :name
    column :economist
    default_actions
  end
end

