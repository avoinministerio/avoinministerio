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

ActiveRecord::Schema.define(:version => 20120304183018) do

  create_table "administrators", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                       :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "administrators", ["email"], :name => "index_administrators_on_email", :unique => true
  add_index "administrators", ["reset_password_token"], :name => "index_administrators_on_reset_password_token", :unique => true

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.text     "ingress"
    t.text     "body"
    t.string   "article_type"
    t.integer  "idea_id"
    t.integer  "citizen_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "publish_state", :default => "unpublished"
    t.string   "slug"
  end

  add_index "articles", ["slug"], :name => "index_articles_on_slug", :unique => true

  create_table "authentications", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.text     "info"
    t.text     "credentials"
    t.text     "extra"
    t.integer  "citizen_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["citizen_id"], :name => "index_authentications_on_citizen_id"
  add_index "authentications", ["provider", "uid"], :name => "index_authentications_on_provider_and_uid", :unique => true

  create_table "citizens", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "password"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "locked_at"
  end

  add_index "citizens", ["email"], :name => "index_citizens_on_email", :unique => true
  add_index "citizens", ["reset_password_token"], :name => "index_citizens_on_reset_password_token", :unique => true

  create_table "comments", :force => true do |t|
    t.integer  "author_id"
    t.text     "body"
    t.boolean  "published",        :default => true
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "publish_state",    :default => "published"
  end

  add_index "comments", ["author_id"], :name => "index_comments_on_author_id"
  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["publish_state"], :name => "index_comments_on_publish_state"

  create_table "ideas", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "state",         :default => "idea"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "summary"
    t.string   "publish_state", :default => "published"
    t.string   "slug"
  end

  add_index "ideas", ["author_id"], :name => "index_ideas_on_author_id"
  add_index "ideas", ["publish_state"], :name => "index_ideas_on_publish_state"
  add_index "ideas", ["slug"], :name => "index_ideas_on_slug", :unique => true

  create_table "profiles", :force => true do |t|
    t.integer  "citizen_id"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
  end

  add_index "profiles", ["citizen_id"], :name => "index_profiles_on_citizen_id"

  create_table "votes", :force => true do |t|
    t.integer  "option"
    t.integer  "idea_id"
    t.integer  "citizen_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["citizen_id"], :name => "index_votes_on_citizen_id"
  add_index "votes", ["idea_id"], :name => "index_votes_on_idea_id"

end
