# spec/dark_trader_spec.rb
require_relative '../lib/dark_trader.rb'

RSpec.describe 'crypto_scrapper' do
  it 'renvoie un array non vide' do
    data = crypto_scrapper
    expect(data).not_to be_empty
  end

  it 'renvoie un array de hash avec des données cohérentes' do
    data = crypto_scrapper
    expect(data.first).to be_a(Hash)
    expect(data.first.keys.first).to be_a(String)
    expect(data.first.values.first).to be_a(Float)
  end
end
