
if ENV["PENDING_MIGRATIONS"]
  puts "[initializer] Skipping initialization of RESOURCE_OFFER_HANDLER due to pending migrations"
  RESOURCE_OFFER_HANDLER = nil
else 
  RESOURCE_OFFER_HANDLER = ResourceOfferHandler.new
end
