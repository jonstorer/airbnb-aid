class RoomWorker
  include Sidekiq::Worker

  def perform(options)
    options.symbolize_keys!
    $sidekiq_logger.info("___ opts  ___")
    $sidekiq_logger.info options.inspect
    $sidekiq_logger.info("____________")
    begin
      properties = Airbnb::Property.fetch(options)
      $sidekiq_logger.info("___ ids ___")
      $sidekiq_logger.info properties.map(&:id).join(', ')
      $sidekiq_logger.info("___________")
      properties.each do |property|

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
            room.save!
          else
            $sidekiq_logger.info("created #{property.id}")
            Room.create(attributes)
          end
        end
      end
    rescue Exception => e
      $sidekiq_logger.info("___ err  ___")
      $sidekiq_logger.info e.inspect
      $sidekiq_logger.info("___________")
    end
  end
end
