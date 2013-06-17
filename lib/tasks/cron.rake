namespace :aa do
  namespace :cron do
    desc 'Run these nightly'
    task :nightly => []

    desc 'Run these every hour'
    task :hourly => []

    desc 'Run these every 4 hours'
    task :four_hourly => []

    desc 'Run these every month'
    task :monthly => []

    desc 'load new listings'
    task :load_listings => :eager_load_environment do
      count = Airbnb::Property.count
      unless count.zero?
        pages = ( count.to_f / 100.to_f ).to_i
        (1..pages).each do |page|
          RoomWorker.perform_async(page)
        end
      end
    end
  end
end
