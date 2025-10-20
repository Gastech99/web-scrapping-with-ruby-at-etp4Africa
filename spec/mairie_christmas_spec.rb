require 'rspec'
require_relative '../lib/mairie_christmas'

describe "Mairie Christmas scraper" do
  it "récupère un e-mail depuis une page mairie" do
    url = "http://annuaire-des-mairies.com/95/avernes.html"
    email = get_townhall_email(url)
    
    expect(email).to be_a(String)
    expect(email).to include('@')
    expect(email).to include('.')
  end
  
  it "récupère les URLs des mairies du Val d'Oise" do
    towns = get_townhall_urls
    
    expect(towns).to be_a(Array)
    expect(towns).not_to be_empty
    expect(towns.first).to be_a(Hash)
    expect(towns.first).to have_key(:name)
    expect(towns.first).to have_key(:url)
    expect(towns.first[:name]).to be_a(String)
    expect(towns.first[:url]).to include('http')
  end
end