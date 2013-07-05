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
      group = Time.now.hour
      puts "queuing group #{group}"
      Room.where({ :group => group }).each(&:snapshot)
    end

    desc 'load new listings'
    task :load_listings => :eager_load_environment do
      LOCATIONS.each do |location|
        (1..16).each do |number_of_guests|
          query = { :location => location, :number_of_guests => number_of_guests }
          count = [ Airbnb::Property.count(query), 1000 ].min
          unless count.zero?
            pages = ( count.to_f / 10.to_f ).to_i
            (1..pages).each do |page|
              RoomWorker.perform_async(query.merge({ :page => page }))
            end
          end
        end
      end
    end
  end
end
