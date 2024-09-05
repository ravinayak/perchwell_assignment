# frozen_string_literal: true

# config/initializers/run_seeds.rb

begin
  # Check if the database connection is established
  ActiveRecord::Base.connection
  # Run seeds only if in the development.
  # Check if seeds have been run before to avoid rerunning them every time the application starts.
  if Rails.env.development? && !(Rails.application.config.respond_to?(:seeds_ran) && Rails.application.config.seeds_ran)
    puts 'Running db:seed...'
    Rails.application.load_seed # Equivalent to running `rails db:seed`
    Rails.application.config.seeds_ran = true
  end
rescue ActiveRecord::NoDatabaseError
  # Do nothing, as the database is not created yet
  puts 'Database does not exist. Skipping seeding.'
end
