class RoomWorker
  include Sidekiq::Worker

  def perform(page)
    Airbnb::Property.fetch(:page => page).each do |property|
      $sidekiq_logger.info("result start")
      $sidekiq_logger.info property
      $sidekiq_logger.info("result end")

      if property.error
        $sidekiq_logger.info(property.error)
      else
          attributes = {
            :aid                 => property.id,
            :name                => property.name,
            :person_capacity     => property.person_capacity,
            :bedrooms            => property.bedrooms,
            :bathrooms           => property.bathrooms,
            :beds                => property.beds,
            :bed_type            => property.bed_type,
            :property_type       => property.property_type,
            :room_type_category  => property.room_type_category,
            :cancellation_policy => property.cancellation_policy,
            :user_id             => property.user_id,
            :reviews_count       => property.reviews_count,
            :location            => [ property.lat, property.lng ],
            :address             => property.address,
            :neighborhood        => property.neighborhood,
            :city                => property.city,
            :country             => property.country,
            :state               => property.state,
            :zipcode             => property.zipcode
          }
        if room = Room.where(:aid => property.id).first
          attributes.delete(:aid)
          $sidekiq_logger.info("updated #{property.id}")
          room.update_attributes(attributes)
        else
          $sidekiq_logger.info("created #{property.id}")
          Room.create(attributes)
        end
      end
    end
  end
end
