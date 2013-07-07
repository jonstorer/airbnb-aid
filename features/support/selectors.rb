module Selectors
  include Rails.application.routes.url_helpers

  def selector_for(named_element)
    case named_element
    # paths
    when /the homepage/
      root_path
    # withins
    when /^(.*) within (.*)$/
      "#{selector_for($2)} #{selector_for($1)}"
    # catch all
    when /^(.+)$/
      puts "Selector for #{$1} was not found."
      puts "Do not commit this code into production."
      $1
    end
  end
end

World(Selectors)
