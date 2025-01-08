if ENV['JAWSDB_URL'].blank? && !Rails.env.test?
    raise "JAWSDB_URL is not set. Please set the JAWSDB_URL environment variable."
end
  