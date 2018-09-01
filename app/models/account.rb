require 'bcrypt'
require 'stellar-sdk'

class Account < ApplicationRecord
  self.primary_key = :public_key

  after_create :start_watching
  after_destroy :stop_watching

  NEW_ACCOUNT_CACHE_KEY = ENV['NEW_ACCOUNT_CACHE_KEY']

  def start_watching
    StellarFed::Application::CACHE_CLIENT.hset(NEW_ACCOUNT_CACHE_KEY, public_key, email)
  rescue => e
    logger.warn e
  end

  def stop_watching
    StellarFed::Application::CACHE_CLIENT.hdel(NEW_ACCOUNT_CACHE_KEY, public_key)
  rescue => e
    logger.warn e
  end

  def self.update_watch
    watched_accounts = StellarFed::Application::CACHE_CLIENT.hkeys(NEW_ACCOUNT_CACHE_KEY)
    watched_accounts.each do |k|
      StellarFed::Application::CACHE_CLIENT.hdel(NEW_ACCOUNT_CACHE_KEY, k)
    end
    Account.find_each(&:start_watching)
  rescue => e
    logger.warn e
  end

  def self.find_or_create(email)
    key_pair = Stellar::KeyPair.random
    create_with(public_key: key_pair.address, secret_key: key_pair.seed)
      .find_or_create_by(email: email)
  end

  def hashed_address
    ::BCrypt::Engine.hash_secret(public_key, Rails.application.secrets.salt).to_s
  end

  def balance
    account = Stellar::Account.from_seed(secret_key)
    account_info = Rails.application.config.stellar_client.account_info(account)
    account_info.balances.find { |b| b['asset_type'] == 'native' }['balance']
  rescue => e
    logger.warn e
    return 0
  end
end
