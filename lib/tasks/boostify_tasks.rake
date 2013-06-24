require 'boostify'

namespace :boostify do
  desc 'Sync your favorite Charities with Boost'
  task sync_charities: :environment do
    Boostify::Jobs::SyncCharities.perform
  end
end
