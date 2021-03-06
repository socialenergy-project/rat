# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_05_130357) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "building_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cl_scenarios", force: :cascade do |t|
    t.string "name"
    t.string "algorithm"
    t.integer "kappa"
    t.datetime "starttime"
    t.datetime "endtime"
    t.bigint "interval_id"
    t.bigint "clustering_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.float "cost_parameter"
    t.bigint "flexibility_id"
    t.text "stderr"
    t.string "error_message"
    t.index ["clustering_id"], name: "index_cl_scenarios_on_clustering_id"
    t.index ["flexibility_id"], name: "index_cl_scenarios_on_flexibility_id"
    t.index ["interval_id"], name: "index_cl_scenarios_on_interval_id"
    t.index ["user_id"], name: "index_cl_scenarios_on_user_id"
  end

  create_table "cl_scenarios_consumers", id: false, force: :cascade do |t|
    t.bigint "consumer_id", null: false
    t.bigint "cl_scenario_id", null: false
    t.index ["cl_scenario_id", "consumer_id"], name: "index_cl_scenarios_consumers_on_cl_scenario_id_and_consumer_id"
    t.index ["consumer_id", "cl_scenario_id"], name: "index_cl_scenarios_consumers_on_consumer_id_and_cl_scenario_id"
  end

  create_table "cl_scenarios_energy_programs", id: false, force: :cascade do |t|
    t.bigint "cl_scenario_id", null: false
    t.bigint "energy_program_id", null: false
    t.index ["cl_scenario_id", "energy_program_id"], name: "index_cl_scen_ep"
    t.index ["energy_program_id", "cl_scenario_id"], name: "index_ep_cl_scen"
  end

  create_table "clusterings", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "communities", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "clustering_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["clustering_id"], name: "index_communities_on_clustering_id"
  end

  create_table "communities_consumers", id: false, force: :cascade do |t|
    t.bigint "consumer_id", null: false
    t.bigint "community_id", null: false
    t.index ["community_id", "consumer_id"], name: "index_communities_consumers_on_community_id_and_consumer_id"
    t.index ["consumer_id", "community_id"], name: "index_communities_consumers_on_consumer_id_and_community_id"
  end

  create_table "connection_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "consumer_categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "real_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "reference_year"
  end

  create_table "consumers", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.string "edms_id"
    t.bigint "building_type_id"
    t.bigint "connection_type_id"
    t.float "location_x"
    t.float "location_y"
    t.string "feeder_id"
    t.bigint "consumer_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "energy_program_id"
    t.index ["building_type_id"], name: "index_consumers_on_building_type_id"
    t.index ["connection_type_id"], name: "index_consumers_on_connection_type_id"
    t.index ["consumer_category_id"], name: "index_consumers_on_consumer_category_id"
    t.index ["edms_id"], name: "index_consumers_on_edms_id", unique: true
    t.index ["energy_program_id"], name: "index_consumers_on_energy_program_id"
  end

  create_table "consumers_recommendations", id: false, force: :cascade do |t|
    t.bigint "recommendation_id", null: false
    t.bigint "consumer_id", null: false
    t.index ["consumer_id", "recommendation_id"], name: "cons_rec"
    t.index ["recommendation_id", "consumer_id"], name: "rec_cons"
  end

  create_table "consumers_scenarios", id: false, force: :cascade do |t|
    t.bigint "scenario_id", null: false
    t.bigint "consumer_id", null: false
    t.index ["consumer_id", "scenario_id"], name: "index_consumers_scenarios_on_consumer_id_and_scenario_id", unique: true
    t.index ["scenario_id", "consumer_id"], name: "index_consumers_scenarios_on_scenario_id_and_consumer_id", unique: true
  end

  create_table "consumers_users", id: false, force: :cascade do |t|
    t.bigint "consumer_id", null: false
    t.bigint "user_id", null: false
  end

  create_table "data_points", force: :cascade do |t|
    t.bigint "consumer_id"
    t.bigint "interval_id"
    t.datetime "timestamp"
    t.float "consumption"
    t.float "flexibility"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["consumer_id"], name: "index_data_points_on_consumer_id"
    t.index ["interval_id"], name: "index_data_points_on_interval_id"
    t.index ["timestamp", "consumer_id", "interval_id"], name: "index_data_points_on_timestamp_and_consumer_id_and_interval_id", unique: true
    t.index ["timestamp", "consumer_id"], name: "index_data_points_on_timestamp_and_consumer_id"
    t.index ["timestamp", "interval_id"], name: "index_data_points_on_timestamp_and_interval_id"
    t.index ["timestamp"], name: "index_data_points_on_timestamp"
  end

  create_table "ecc_factors", force: :cascade do |t|
    t.integer "period"
    t.integer "start"
    t.integer "stop"
    t.bigint "ecc_term_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ecc_term_id"], name: "index_ecc_factors_on_ecc_term_id"
  end

  create_table "ecc_terms", force: :cascade do |t|
    t.bigint "ecc_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ecc_type_id"], name: "index_ecc_terms_on_ecc_type_id"
  end

  create_table "ecc_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "energy_programs", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "energy_programs_scenarios", id: false, force: :cascade do |t|
    t.bigint "scenario_id", null: false
    t.bigint "energy_program_id", null: false
    t.index ["energy_program_id", "scenario_id"], name: "index_energy_program_scenario", unique: true
    t.index ["scenario_id", "energy_program_id"], name: "index_scenario_energy_program", unique: true
  end

  create_table "flexibilities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "game_activities", force: :cascade do |t|
    t.integer "totalScore"
    t.bigint "user_id"
    t.integer "dailyScore"
    t.integer "gameDuration"
    t.datetime "timestampUserLoggediIn"
    t.string "energyProgram"
    t.string "levelGame"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "timestampUserLoggediIn", "totalScore", "dailyScore", "gameDuration", "energyProgram", "levelGame"], name: "game_act_uniq", unique: true
    t.index ["user_id"], name: "index_game_activities_on_user_id"
  end

  create_table "game_rewards", force: :cascade do |t|
    t.integer "total_credits"
    t.integer "total_cash"
    t.integer "total_ex_points"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "total_credits", "total_cash", "total_ex_points"], name: "game_rewards_uniq", unique: true
    t.index ["user_id"], name: "index_game_rewards_on_user_id"
  end

  create_table "group_memberships", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "group_id"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_memberships_on_group_id"
    t.index ["user_id"], name: "index_group_memberships_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "intervals", force: :cascade do |t|
    t.string "name"
    t.integer "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lcms_badges", force: :cascade do |t|
    t.string "topic"
    t.string "level"
    t.float "numeric"
    t.bigint "user_id"
    t.date "date_given"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "topic", "level", "numeric", "date_given"], name: "lcms_badge_uniq", unique: true
    t.index ["user_id"], name: "index_lcms_badges_on_user_id"
  end

  create_table "lcms_courses", force: :cascade do |t|
    t.string "topic"
    t.string "level"
    t.float "numeric"
    t.bigint "user_id"
    t.datetime "graded_at"
    t.float "current_grade"
    t.integer "time_spent_seconds"
    t.float "grade_min"
    t.float "grade_max"
    t.float "grade_pass"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "topic", "level", "numeric", "graded_at", "current_grade", "grade_min", "grade_max"], name: "lcms_courses_uniq", unique: true
    t.index ["user_id"], name: "index_lcms_courses_on_user_id"
  end

  create_table "lcms_scores", force: :cascade do |t|
    t.integer "competence"
    t.float "current_score"
    t.float "last_week_score"
    t.float "last_month_score"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "competence", "current_score", "last_week_score", "last_month_score"], name: "lcms_scores_uniq", unique: true
    t.index ["user_id"], name: "index_lcms_scores_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "sender_id"
    t.bigint "recipient_id"
    t.bigint "recommendation_id"
    t.text "content"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "gsrn_status", default: 0
    t.index ["recipient_id"], name: "index_messages_on_recipient_id"
    t.index ["recommendation_id"], name: "index_messages_on_recommendation_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "recommendation_types", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recommendations", force: :cascade do |t|
    t.integer "status", default: 0
    t.bigint "recommendation_type_id"
    t.bigint "recommendable_id"
    t.string "parameter"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "custom_message"
    t.string "recommendable_type"
    t.index ["recommendable_id"], name: "index_recommendations_on_recommendable_id"
    t.index ["recommendation_type_id"], name: "index_recommendations_on_recommendation_type_id"
  end

  create_table "recommendations_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "recommendation_id", null: false
    t.index ["recommendation_id", "user_id"], name: "index_recommendations_users_on_recommendation_id_and_user_id"
    t.index ["user_id", "recommendation_id"], name: "index_recommendations_users_on_user_id_and_recommendation_id"
  end

  create_table "results", force: :cascade do |t|
    t.bigint "scenario_id"
    t.bigint "energy_program_id"
    t.datetime "timestamp"
    t.float "energy_cost"
    t.float "user_welfare"
    t.float "retailer_profit"
    t.float "total_welfare"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "total_consumption"
    t.float "total_bill"
    t.index ["energy_program_id"], name: "index_results_on_energy_program_id"
    t.index ["scenario_id"], name: "index_results_on_scenario_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "scenarios", force: :cascade do |t|
    t.string "name"
    t.datetime "starttime"
    t.datetime "endtime"
    t.bigint "interval_id"
    t.bigint "ecc_type_id"
    t.float "energy_cost_parameter"
    t.float "profit_margin_parameter"
    t.bigint "flexibility_id"
    t.float "gamma_parameter"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "stderr"
    t.bigint "user_id"
    t.string "error_message"
    t.integer "number_of_clusters"
    t.text "description"
    t.index ["ecc_type_id"], name: "index_scenarios_on_ecc_type_id"
    t.index ["flexibility_id"], name: "index_scenarios_on_flexibility_id"
    t.index ["interval_id"], name: "index_scenarios_on_interval_id"
    t.index ["user_id"], name: "index_scenarios_on_user_id"
  end

  create_table "smart_plugs", force: :cascade do |t|
    t.bigint "consumer_id"
    t.string "name"
    t.string "mqtt_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["consumer_id"], name: "index_smart_plugs_on_consumer_id"
  end

  create_table "user_clustering_parameters", force: :cascade do |t|
    t.bigint "user_clustering_scenario_id"
    t.bigint "user_id"
    t.string "paramtype"
    t.float "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_clustering_scenario_id"], name: "index_user_clustering_parameters_on_user_clustering_scenario_id"
    t.index ["user_id"], name: "index_user_clustering_parameters_on_user_id"
  end

  create_table "user_clustering_results", force: :cascade do |t|
    t.bigint "user_clustering_scenario_id"
    t.bigint "user_id"
    t.integer "cluster"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_clustering_scenario_id"], name: "index_user_clustering_results_on_user_clustering_scenario_id"
    t.index ["user_id"], name: "index_user_clustering_results_on_user_id"
  end

  create_table "user_clustering_scenarios", force: :cascade do |t|
    t.integer "kappa"
    t.float "silhouette"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "authentication_token", limit: 30
    t.string "provider"
    t.string "uid"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "cl_scenarios", "clusterings"
  add_foreign_key "cl_scenarios", "flexibilities"
  add_foreign_key "cl_scenarios", "intervals"
  add_foreign_key "cl_scenarios", "users"
  add_foreign_key "communities", "clusterings"
  add_foreign_key "consumers", "building_types"
  add_foreign_key "consumers", "connection_types"
  add_foreign_key "consumers", "consumer_categories"
  add_foreign_key "consumers", "energy_programs"
  add_foreign_key "data_points", "consumers"
  add_foreign_key "data_points", "intervals"
  add_foreign_key "ecc_factors", "ecc_terms"
  add_foreign_key "ecc_terms", "ecc_types"
  add_foreign_key "game_activities", "users"
  add_foreign_key "game_rewards", "users"
  add_foreign_key "group_memberships", "groups"
  add_foreign_key "group_memberships", "users"
  add_foreign_key "lcms_badges", "users"
  add_foreign_key "lcms_courses", "users"
  add_foreign_key "lcms_scores", "users"
  add_foreign_key "messages", "recommendations"
  add_foreign_key "messages", "users", column: "recipient_id"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "recommendations", "recommendation_types"
  add_foreign_key "results", "energy_programs"
  add_foreign_key "results", "scenarios"
  add_foreign_key "scenarios", "ecc_types"
  add_foreign_key "scenarios", "flexibilities"
  add_foreign_key "scenarios", "intervals"
  add_foreign_key "scenarios", "users"
  add_foreign_key "smart_plugs", "consumers"
  add_foreign_key "user_clustering_parameters", "user_clustering_scenarios"
  add_foreign_key "user_clustering_parameters", "users"
  add_foreign_key "user_clustering_results", "user_clustering_scenarios"
  add_foreign_key "user_clustering_results", "users"
end
