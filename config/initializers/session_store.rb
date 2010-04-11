# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_urdb_session',
  :secret      => '41339581caa78f013d9895f38863fdb281922299e5901c05439f36e799bf82289c38af04ceed07f650dfc2de8ca427fb0787ccc2f1669d589f32a65a3d632050'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
