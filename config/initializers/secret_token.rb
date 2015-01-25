# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
ArchaicSmiles::Application.config.secret_key_base = ENV['SECRET_KEY_BASE'] || 'e905b14c5543d3cb5c9eb31b2597a3d739d7526dbeef5269518098a9d657706d73de741a632600ee13508f22ef6f76ae9cfe7342952767b1ba6fcc7caec15b6f'
