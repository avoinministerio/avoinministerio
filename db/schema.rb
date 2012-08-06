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

ActiveRecord::Schema.define(:version => 20120806062640) do

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

  create_table "changelogs", :force => true do |t|
    t.string   "changer_type"
    t.integer  "changer_id"
    t.string   "changelogged_type"
    t.integer  "changelogged_id"
    t.string   "change_type"
    t.text     "attribute_changes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "changelogs", ["changelogged_type", "changelogged_id"], :name => "index_changelogs_on_changelogged_type_and_changelogged_id"
  add_index "changelogs", ["changer_type", "changer_id"], :name => "index_changelogs_on_changer_type_and_changer_id"

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

  create_table "expert_suggestions", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.string   "jobtitle"
    t.string   "organisation"
    t.string   "expertise"
    t.string   "recommendation"
    t.integer  "citizen_id"
    t.integer  "idea_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ideas", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "state",                              :default => "idea"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "summary"
    t.string   "publish_state",                      :default => "published"
    t.string   "slug"
    t.integer  "comment_count",                      :default => 0
    t.integer  "vote_count",                         :default => 0
    t.integer  "vote_for_count",                     :default => 0
    t.integer  "vote_against_count",                 :default => 0
    t.float    "vote_proportion",                    :default => 0.0
    t.float    "vote_proportion_away_mid",           :default => 0.5
    t.boolean  "collecting_started"
    t.boolean  "collecting_ended"
    t.date     "collecting_start_date"
    t.date     "collecting_end_date"
    t.integer  "additional_signatures_count"
    t.date     "additional_signatures_count_date"
    t.integer  "target_count"
    t.boolean  "collecting_in_service"
    t.string   "additional_collecting_service_urls"
    t.boolean  "anonymized"
    t.datetime "updated_content_at"
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
    t.boolean  "receive_newsletter",          :default => true
    t.boolean  "receive_other_announcements", :default => true
    t.boolean  "receive_weekletter",          :default => true
    t.string   "first_names"
    t.boolean  "accept_science",              :default => true
    t.boolean  "accept_terms_of_use",         :default => true
  end

  add_index "profiles", ["citizen_id"], :name => "index_profiles_on_citizen_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "signatures", :force => true do |t|
    t.integer  "citizen_id"
    t.integer  "idea_id"
    t.string   "idea_title"
    t.date     "idea_date"
    t.date     "birth_date"
    t.string   "occupancy_county"
    t.boolean  "vow"
    t.date     "signing_date"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stamp"
    t.datetime "started"
    t.string   "firstnames"
    t.string   "lastname"
    t.boolean  "accept_general"
    t.boolean  "accept_non_eu_server"
    t.string   "accept_publicity"
    t.boolean  "accept_science"
    t.string   "idea_mac"
  end

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
