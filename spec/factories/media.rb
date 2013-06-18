# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :medium do
    app          "app"
    context      "context"
    locale       "sv-SE"
    tags         "foo,bar,baz"
    content_type "text/plain"
    file_name    "cartmans_mom.txt"
    bytesize     { rand(100000) }
    name         { "name#{rand(10000)}" }
    lock_version 0
    created_by   { rand(10000) }
    updated_by   { rand(10000) }
    delete_at    { 1.month.from_now }
    email        "someone@example.com"
    usage        ""
  end
end
