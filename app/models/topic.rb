class Topic < ActiveRecord::Base
  attr_accessible :name
  has_many :posts


    def self.list_topic_options 
    Topic.select("id, name").map {|x| [x.id, x.name] }
  end
end
