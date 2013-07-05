LOCATIONS = YAML::load_file(File.join(Rails.root.to_s, 'config', 'locations.yml'))[:locations].freeze
