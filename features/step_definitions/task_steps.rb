Given /^the nightly report job ran$/ do
  Listing.all.each do |listing|
    #ReportWorker.new.perform(listing.id)
  end
end
