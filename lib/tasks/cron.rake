namespace :aa do
  namespace :cron do
    desc 'Run these nightly'
    task :nightly => [:load_listings]

    desc 'Run these every 30 minutes'
    task :every_30_minutes => [:update_rooms]

    desc 'Run these every hour'
    task :hourly => []

    desc 'Run these every 4 hours'
    task :four_hourly => []

    desc 'Run these every month'
    task :monthly => []

    desc 'update rooms'
    task :update_rooms => :eager_load_environment do
      group = ( Time.now.hour * 2 ) + ( Time.now.min > 29 ? 1 : 0 )
      Room.where({ :group => group }).each(&:async_update)
    end

    desc 'load new listings'
    task :load_listings => :eager_load_environment do
      count = Airbnb::Property.count
      unless count.zero?
        pages = ( count.to_f / 10.to_f ).to_i
        (1..pages).each do |page|
          RoomWorker.perform_async(page)
        end
      end
    end
  end
end
