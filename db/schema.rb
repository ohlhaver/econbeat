# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121202194140) do

  create_table "actions", :force => true do |t|
    t.integer  "subject_type"
    t.integer  "action_type"
    t.integer  "object_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "article_id"
    t.integer  "post_id"
    t.integer  "user_id"
    t.integer  "catcher_id"
    t.integer  "author_obj_id"
    t.boolean  "hidden"
    t.string   "fbaction_id"
  end

  add_index "actions", ["catcher_id"], :name => "index_actions_on_author_id"
  add_index "actions", ["user_id"], :name => "index_actions_on_user_id"

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.string   "teaser"
    t.integer  "feed_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "catcher_id"
    t.integer  "source_id"
    t.string   "summary"
  end

  add_index "articles", ["title", "catcher_id"], :name => "index_articles_on_title_and_catcher_id", :unique => true
  add_index "articles", ["title", "source_id"], :name => "index_articles_on_title_and_source_id", :unique => true
  add_index "articles", ["url"], :name => "index_articles_on_url", :unique => true

  create_table "authors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "hidden"
    t.string   "img_url"
    t.boolean  "economist"
  end

  add_index "authors", ["name"], :name => "index_authors_on_name", :unique => true

  create_table "catchers", :force => true do |t|
    t.string   "name"
    t.integer  "author_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "catchers", ["name"], :name => "index_catchers_on_name", :unique => true

  create_table "comments", :force => true do |t|
    t.text     "text"
    t.integer  "user_id"
    t.integer  "post_id"
    t.string   "fbid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "article_id"
    t.integer  "action_id"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "econlists", :force => true do |t|
    t.text     "top_authors"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "facebook_updates", :force => true do |t|
    t.string   "uid"
    t.string   "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "feeds", :force => true do |t|
    t.string   "name"
    t.string   "authors"
    t.text     "url"
    t.string   "sha"
    t.boolean  "active"
    t.integer  "frequency_in_seconds"
    t.datetime "last_crawled_at"
    t.datetime "next_crawl_at"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "source_id"
    t.boolean  "scraper"
    t.boolean  "copy_scraper"
    t.boolean  "paused"
  end

  add_index "feeds", ["next_crawl_at"], :name => "index_feeds_on_next_crawl_at"
  add_index "feeds", ["sha"], :name => "index_feeds_on_sha"

  create_table "filters", :force => true do |t|
    t.integer  "user_id"
    t.integer  "utopic_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "filters", ["user_id"], :name => "index_filters_on_user_id"

  create_table "invitations", :force => true do |t|
    t.integer  "sender_id"
    t.string   "recipient_email"
    t.string   "token"
    t.datetime "sent_at"
    t.string   "new"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "likes", :force => true do |t|
    t.string   "fbid"
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "article_id"
  end

  create_table "lists", :force => true do |t|
    t.text     "top_authors"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "posts", :force => true do |t|
    t.string   "headline"
    t.string   "url"
    t.integer  "user_id"
    t.integer  "category_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "description"
    t.string   "author"
    t.integer  "topic_id"
    t.integer  "utopic_id"
    t.string   "fbid"
    t.string   "comment"
    t.string   "picture"
    t.boolean  "hidden"
    t.boolean  "starred"
    t.integer  "via_id"
    t.string   "fbaction_id"
    t.integer  "comments_count"
    t.integer  "likes_count"
    t.boolean  "public"
    t.boolean  "facebook"
    t.boolean  "email"
    t.integer  "position"
  end

  add_index "posts", ["fbid"], :name => "index_posts_on_fbid", :unique => true
  add_index "posts", ["topic_id"], :name => "index_posts_on_topic_id"
  add_index "posts", ["user_id", "created_at"], :name => "index_posts_on_user_id_and_created_at"
  add_index "posts", ["utopic_id"], :name => "index_posts_on_utopic_id"

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], :name => "index_relationships_on_follower_id_and_followed_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "scraper_rules", :force => true do |t|
    t.integer  "feed_id"
    t.string   "label"
    t.text     "value"
    t.text     "match"
    t.text     "test_url"
    t.integer  "position",   :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "scraper_rules", ["feed_id"], :name => "index_scraper_rules_on_feed_id"

  create_table "sources", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "stop_words", :force => true do |t|
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "author_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "starred"
  end

  add_index "subscriptions", ["user_id", "author_id"], :name => "index_subscriptions_on_user_id_and_author_id", :unique => true

  create_table "topics", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "name"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.integer  "invitation_id"
    t.integer  "invitation_limit"
    t.string   "provider"
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.string   "picture"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["name"], :name => "index_users_on_name", :unique => true
  add_index "users", ["uid"], :name => "index_users_on_uid", :unique => true

  create_table "utopics", :force => true do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "utopics", ["user_id"], :name => "index_utopics_on_user_id"

end
