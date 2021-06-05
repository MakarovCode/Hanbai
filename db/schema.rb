# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_03_02_002507) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_id", null: false
    t.string "resource_type", null: false
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "activities", id: :serial, force: :cascade do |t|
    t.string "title"
    t.integer "activity_type_id"
    t.datetime "date_and_time"
    t.integer "duration"
    t.integer "user_id"
    t.integer "creator_user_id"
    t.integer "deal_id"
    t.integer "person_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "done_time"
    t.index ["activity_type_id"], name: "index_activities_on_activity_type_id"
    t.index ["creator_user_id"], name: "index_activities_on_creator_user_id"
    t.index ["deal_id"], name: "index_activities_on_deal_id"
    t.index ["person_id"], name: "index_activities_on_person_id"
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "activity_types", id: :serial, force: :cascade do |t|
    t.string "icon"
    t.string "name"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_activity_types_on_user_id"
  end

  create_table "admin_users", force: :cascade do |t|
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "ahoy_events", force: :cascade do |t|
    t.integer "visit_id"
    t.integer "user_id"
    t.string "name"
    t.json "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["user_id", "name"], name: "index_ahoy_events_on_user_id_and_name"
    t.index ["visit_id", "name"], name: "index_ahoy_events_on_visit_id_and_name"
  end

  create_table "attachments", id: :serial, force: :cascade do |t|
    t.integer "deal_id"
    t.integer "person_id"
    t.string "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deal_id"], name: "index_attachments_on_deal_id"
    t.index ["person_id"], name: "index_attachments_on_person_id"
  end

  create_table "companies", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "notes"
    t.string "address"
    t.integer "user_id"
    t.integer "people_count", default: 0
    t.integer "open_deals_count", default: 0
    t.integer "won_deals_count", default: 0
    t.integer "closed_deal_count", default: 0
    t.integer "activities_count", default: 0
    t.integer "done_activities_count", default: 0
    t.integer "undone_activities_count", default: 0
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_companies_on_user_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "subject"
    t.text "message"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_contacts_on_user_id"
  end

  create_table "coupons", id: :serial, force: :cascade do |t|
    t.string "token"
    t.date "expiration_date"
    t.string "kind"
    t.float "value"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "deals", id: :serial, force: :cascade do |t|
    t.string "title"
    t.integer "creator_user_id"
    t.integer "user_id"
    t.float "value"
    t.float "tax"
    t.float "total"
    t.float "commission"
    t.integer "stage_id"
    t.integer "person_id"
    t.datetime "stage_change_time"
    t.datetime "won_time"
    t.datetime "lost_time"
    t.datetime "close_time"
    t.text "lost_reason"
    t.integer "activities_count", default: 0
    t.integer "done_activities_count", default: 0
    t.integer "undone_activities_count", default: 0
    t.integer "status"
    t.string "currency"
    t.integer "priority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "estimated_close_date"
    t.index ["creator_user_id"], name: "index_deals_on_creator_user_id"
    t.index ["person_id"], name: "index_deals_on_person_id"
    t.index ["stage_id"], name: "index_deals_on_stage_id"
    t.index ["user_id"], name: "index_deals_on_user_id"
  end

  create_table "easy_pay_u_latam_payu_payments", force: :cascade do |t|
    t.integer "status"
    t.date "start_date"
    t.date "end_date"
    t.string "period"
    t.string "reference_code"
    t.string "description"
    t.float "amount"
    t.float "tax"
    t.float "tax_return_base"
    t.string "currency"
    t.string "buyer_full_name"
    t.string "buyer_email"
    t.string "shipping_address"
    t.string "shipping_city"
    t.string "shipping_country"
    t.string "buyer_phone"
    t.integer "transaction_state"
    t.float "risk"
    t.string "reference_pol"
    t.integer "installments_units"
    t.datetime "processing_date"
    t.string "cus"
    t.string "pse_bank"
    t.string "response_code"
    t.string "payment_method"
    t.string "payment_method_type"
    t.string "payment_method_name"
    t.string "payment_request_state"
    t.string "franchise"
    t.string "lap_transaction_state"
    t.string "message"
    t.string "authorization_code"
    t.string "transaction_id"
    t.string "trazability_code"
    t.string "state_pol"
    t.string "number_card"
    t.string "payer_name"
    t.string "billing_country"
    t.string "response_message_pol"
    t.string "sign"
    t.string "billing_address"
    t.string "billing_city"
    t.string "buyer_nickname"
    t.string "bank_id"
    t.string "customer_number"
    t.float "administrative_fee_base"
    t.integer "attempts"
    t.string "merchant_id"
    t.string "exchange_rate"
    t.string "ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_easy_pay_u_latam_payu_payments_on_user_id"
  end

  create_table "extra_field_contacts", force: :cascade do |t|
    t.bigint "extra_field_id"
    t.bigint "person_id"
    t.string "value"
    t.integer "kind"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["extra_field_id"], name: "index_extra_field_contacts_on_extra_field_id"
    t.index ["person_id"], name: "index_extra_field_contacts_on_person_id"
  end

  create_table "extra_field_deals", force: :cascade do |t|
    t.bigint "extra_field_id"
    t.bigint "deal_id"
    t.string "value"
    t.integer "kind"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deal_id"], name: "index_extra_field_deals_on_deal_id"
    t.index ["extra_field_id"], name: "index_extra_field_deals_on_extra_field_id"
  end

  create_table "extra_fields", force: :cascade do |t|
    t.string "name"
    t.integer "kind"
    t.boolean "required"
    t.integer "object_type"
    t.bigint "funnel_id"
    t.bigint "user_id"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["funnel_id"], name: "index_extra_fields_on_funnel_id"
    t.index ["user_id"], name: "index_extra_fields_on_user_id"
  end

  create_table "funnels", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.string "image"
    t.integer "user_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_funnels_on_user_id"
  end

  create_table "history_logs", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "funnel_id"
    t.bigint "stage_id"
    t.bigint "deal_id"
    t.bigint "activity_id"
    t.text "action_text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["activity_id"], name: "index_history_logs_on_activity_id"
    t.index ["deal_id"], name: "index_history_logs_on_deal_id"
    t.index ["funnel_id"], name: "index_history_logs_on_funnel_id"
    t.index ["stage_id"], name: "index_history_logs_on_stage_id"
    t.index ["user_id"], name: "index_history_logs_on_user_id"
  end

  create_table "information", force: :cascade do |t|
    t.string "title"
    t.string "main_image"
    t.string "main_title"
    t.string "main_text"
    t.string "main_sub_text"
    t.string "main_color"
    t.string "services_title"
    t.string "services_text"
    t.string "contact_info"
    t.string "contact_text"
    t.string "contact_title"
    t.string "login_title"
    t.string "login_text"
    t.string "login_image"
    t.string "register_title"
    t.string "register_text"
    t.string "register_image"
    t.string "logo"
    t.string "rights"
    t.text "about_us"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "service1_title"
    t.string "service1_icon"
    t.string "service1_text"
    t.string "service2_title"
    t.string "service2_icon"
    t.string "service2_text"
    t.string "service3_title"
    t.string "service3_icon"
    t.string "service3_text"
    t.string "video"
    t.string "video_title"
    t.string "video_text"
    t.string "call_to_action_blog_title"
    t.string "call_to_action_blog_text"
    t.string "logo_inverse"
    t.string "call_to_action_blog_image"
  end

  create_table "notes", force: :cascade do |t|
    t.bigint "company_id"
    t.bigint "person_id"
    t.bigint "user_id"
    t.text "text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "activity_id"
    t.index ["activity_id"], name: "index_notes_on_activity_id"
    t.index ["company_id"], name: "index_notes_on_company_id"
    t.index ["person_id"], name: "index_notes_on_person_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "payments", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "period"
    t.datetime "pay_time"
    t.float "subtotal"
    t.float "iva"
    t.float "total"
    t.float "discount"
    t.integer "coupon_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coupon_id"], name: "index_payments_on_coupon_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "people", id: :serial, force: :cascade do |t|
    t.integer "company_id"
    t.string "name"
    t.text "notes"
    t.integer "user_id"
    t.integer "open_deals_count", default: 0
    t.integer "won_deals_count", default: 0
    t.integer "closed_deal_count", default: 0
    t.integer "activities_count", default: 0
    t.integer "done_activities_count", default: 0
    t.integer "undone_activities_count", default: 0
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.index ["company_id"], name: "index_people_on_company_id"
    t.index ["user_id"], name: "index_people_on_user_id"
  end

  create_table "person_addresses", force: :cascade do |t|
    t.bigint "person_id"
    t.string "address"
    t.string "kind"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["person_id"], name: "index_person_addresses_on_person_id"
  end

  create_table "person_emails", id: :serial, force: :cascade do |t|
    t.integer "person_id"
    t.string "email"
    t.string "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_person_emails_on_person_id"
  end

  create_table "person_phones", id: :serial, force: :cascade do |t|
    t.integer "person_id"
    t.string "phone"
    t.string "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_person_phones_on_person_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.string "tags"
    t.string "image"
    t.string "video"
    t.string "author"
    t.date "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "setups", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.boolean "remember_me_notifications", default: true
    t.string "token_api"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "moment_to_be_remember"
    t.index ["user_id"], name: "index_setups_on_user_id"
  end

  create_table "stages", id: :serial, force: :cascade do |t|
    t.string "name"
    t.boolean "is_standing"
    t.integer "priority"
    t.integer "funnel_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["funnel_id"], name: "index_stages_on_funnel_id"
  end

  create_table "user_deals", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "deal_id"
    t.string "permission"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deal_id"], name: "index_user_deals_on_deal_id"
    t.index ["user_id"], name: "index_user_deals_on_user_id"
  end

  create_table "user_funnels", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "funnel_id"
    t.string "permission"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tmp_user_id"
    t.index ["funnel_id"], name: "index_user_funnels_on_funnel_id"
    t.index ["user_id"], name: "index_user_funnels_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "uuid"
    t.string "image"
    t.string "how"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "authentication_token", limit: 30
    t.date "birthday"
    t.string "profession"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "visits", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.text "landing_page"
    t.integer "user_id"
    t.string "referring_domain"
    t.string "search_keyword"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.integer "screen_height"
    t.integer "screen_width"
    t.string "country"
    t.string "region"
    t.string "city"
    t.string "postal_code"
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_visits_on_user_id"
    t.index ["visit_token"], name: "index_visits_on_visit_token", unique: true
  end

  add_foreign_key "activities", "activity_types"
  add_foreign_key "activities", "deals"
  add_foreign_key "activities", "people"
  add_foreign_key "activities", "users"
  add_foreign_key "activities", "users", column: "creator_user_id"
  add_foreign_key "activity_types", "users"
  add_foreign_key "attachments", "deals"
  add_foreign_key "attachments", "people"
  add_foreign_key "companies", "users"
  add_foreign_key "contacts", "users"
  add_foreign_key "deals", "people"
  add_foreign_key "deals", "stages"
  add_foreign_key "deals", "users"
  add_foreign_key "deals", "users", column: "creator_user_id"
  add_foreign_key "easy_pay_u_latam_payu_payments", "users"
  add_foreign_key "extra_field_contacts", "extra_fields"
  add_foreign_key "extra_field_contacts", "people"
  add_foreign_key "extra_field_deals", "deals"
  add_foreign_key "extra_field_deals", "extra_fields"
  add_foreign_key "extra_fields", "funnels"
  add_foreign_key "extra_fields", "users"
  add_foreign_key "funnels", "users"
  add_foreign_key "history_logs", "activities"
  add_foreign_key "history_logs", "deals"
  add_foreign_key "history_logs", "funnels"
  add_foreign_key "history_logs", "stages"
  add_foreign_key "history_logs", "users"
  add_foreign_key "notes", "activities"
  add_foreign_key "notes", "companies"
  add_foreign_key "notes", "people"
  add_foreign_key "notes", "users"
  add_foreign_key "payments", "coupons"
  add_foreign_key "payments", "users"
  add_foreign_key "people", "companies"
  add_foreign_key "people", "users"
  add_foreign_key "person_addresses", "people"
  add_foreign_key "person_emails", "people"
  add_foreign_key "person_phones", "people"
  add_foreign_key "setups", "users"
  add_foreign_key "stages", "funnels"
  add_foreign_key "user_deals", "deals"
  add_foreign_key "user_deals", "users"
  add_foreign_key "user_funnels", "funnels"
  add_foreign_key "user_funnels", "users"
end
