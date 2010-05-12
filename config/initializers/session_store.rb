# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_bblue_test_session',
  :secret      => '8956d6af09567883bef5b06a4caecda77f0b3205d03b9d06a6b0cb2d31321b587bb31535e639afbcce8c8368e8694cde8f40efa8755b71aeabea2595c5187f42'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
