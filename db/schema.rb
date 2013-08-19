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

ActiveRecord::Schema.define(:version => 20130817202629) do

  create_table "character_class_skills", :force => true do |t|
    t.integer "character_class_id"
    t.integer "skill_id"
    t.integer "from_level"
    t.boolean "automatic"
  end

  create_table "character_classes", :force => true do |t|
    t.string  "name",         :null => false
    t.string  "description"
    t.boolean "playable"
    t.integer "init_health",  :null => false
    t.integer "health_mod",   :null => false
    t.integer "init_skill",   :null => false
    t.integer "skill_mod",    :null => false
    t.integer "init_attack",  :null => false
    t.integer "attack_mod",   :null => false
    t.integer "init_defence", :null => false
    t.integer "defence_mod",  :null => false
    t.integer "init_melee",   :null => false
    t.integer "melee_mod",    :null => false
    t.integer "init_ranged",  :null => false
    t.integer "ranged_mod",   :null => false
    t.integer "init_evade",   :null => false
    t.integer "evade_mod",    :null => false
    t.integer "init_luck",    :null => false
    t.integer "luck_mod",     :null => false
    t.integer "init_speed",   :null => false
    t.integer "speed_mod",    :null => false
  end

  create_table "characters", :force => true do |t|
    t.string   "name",                               :null => false
    t.integer  "character_class_id",                 :null => false
    t.integer  "exp",                :default => 0
    t.integer  "level",              :default => 1
    t.integer  "level_up_target",    :default => 10
    t.integer  "health"
    t.integer  "max_health"
    t.integer  "skill"
    t.integer  "max_skill"
    t.integer  "attack",                             :null => false
    t.integer  "defence",                            :null => false
    t.integer  "melee",                              :null => false
    t.integer  "ranged",                             :null => false
    t.integer  "evade",                              :null => false
    t.integer  "luck",                               :null => false
    t.integer  "speed",                              :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "characters_skills", :force => true do |t|
    t.integer "character_id"
    t.integer "skill_id"
  end

  create_table "skill_effects", :force => true do |t|
    t.string   "name"
    t.string   "target_trait"
    t.integer  "magnitude"
    t.string   "related_trait"
    t.boolean  "defendable"
    t.boolean  "evadeable"
    t.integer  "skill_id"
    t.string   "type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "skills", :force => true do |t|
    t.string   "name"
    t.string   "label"
    t.integer  "skill_cost"
    t.integer  "range"
    t.boolean  "offensive"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
