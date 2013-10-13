config = YAML::load_file(File.join(Rails.root.to_s, 'config', 'airbnb.yml')).freeze
config = config[Rails.env] || config[:default]
Airbnb.config do
  wait_for config[:wait]
end
