# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '__mp3__session',
  :secret      => 'bc53c19849f60e8613694fbb82f0fde448c71486da43c457bd36ff082b7f14718ebce3a3e9e5091376324387aceaf465a8f1480a76bc6d1bb11aebd1905dac42'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
