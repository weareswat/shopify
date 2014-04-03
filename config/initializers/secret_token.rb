# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Invoicexpress::Application.config.secret_token = ENV['SECRET_KEY_BASE'] || 'b10d64ac67f6cc6c8de5c47ed1a258dec0acbaf3e03542d06099bd6db2fad091490387ecd4e71c76e1006249b10ae1c85ab6f3b8461a67f08c656f45b103480b'
