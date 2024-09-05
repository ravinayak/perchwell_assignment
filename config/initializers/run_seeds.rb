# config/initializers/run_seeds.rb

# Run seeds only if in the development.
if Rails.env.development?
  # Check if seeds have been run before to avoid rerunning them every time the application starts.
  unless Rails.application.config.respond_to?(:seeds_ran)&& Rails.application.config.seeds_ran
    puts "Running db:seed..."
    Rails.application.load_seed # Equivalent to running `rails db:seed`
    Rails.application.config.seeds_ran = true
  end
end
