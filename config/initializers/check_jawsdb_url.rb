return if Rails.env.test?

if ENV['JAWSDB_URL'].nil?
  raise "JAWSDB_URL is not set. Please set the JAWSDB_URL environment variable."
end
