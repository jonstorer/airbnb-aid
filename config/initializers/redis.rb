config = YAML.load_file(Rails.root.join('config', 'redis.yml'))[:default]
$redis = Redis.new(config)
