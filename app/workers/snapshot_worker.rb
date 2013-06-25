class SnapshotWorker
  include Sidekiq::Worker

  def perform(id)
    $sidekiq_logger.info("___ id ___")
    $sidekiq_logger.info id
    $sidekiq_logger.info("__________")
    begin
      if room = Room.find(id)
        TorPrivoxy::Agent.new '127.0.0.1', '', { 8123 => 9051 } do |agent|
          #Airbnb.config({:proxy => agent.ip}) do
          #end
          #property = Airbnb::Property.new(Hashie::Mash.new({ :id => room.aid }))
          #attributes = {
          #  :guests_included               => property.guests_included,
          #  :price                         => property.price,
          #  :max_nights                    => property.max_nights,
          #  :min_nights                    => property.min_nights,
          #  :person_capacity               => property.person_capacity,
          #  :price                         => property.price,
          #  :price_for_extra_person_native => property.price_for_extra_person_native,
          #  :reviews_count                 => property.reviews_count,
          #  :security_deposit              => property.security_deposit
          #}
          #room.snapshots.create!(attributes)
        end
      end
    rescue Exception => e
      $sidekiq_logger.info("___ err  ___")
      $sidekiq_logger.info e.inspect
      $sidekiq_logger.info("___________")
      raise e
    end
  end
end
