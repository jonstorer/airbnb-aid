desc 'Eager load environment without using Rails-provided environment task'
task :eager_load_environment do
  require File.join(Rails.root, 'config', 'environment')
end
