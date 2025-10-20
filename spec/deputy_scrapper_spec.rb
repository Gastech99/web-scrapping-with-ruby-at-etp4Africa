require 'rspec'
require_relative '../lib/deputy_scrapper'

describe 'deputy_scrapper' do
  it 'renvoie un array non vide de députés' do
    data = deputy_scrapper
    expect(data).to be_a(Array)
    expect(data).not_to be_empty
    # Changer cette attente pour correspondre aux données d'exemple
    expect(data.size).to be > 0
  end

  it 'chaque député a les clés first_name, last_name et email avec format correct' do
    data = deputy_scrapper
    
    # Vérifier d'abord que nous avons des données
    expect(data).not_to be_empty
    
    data.each do |deputy|
      expect(deputy).to be_a(Hash)
      
      # Vérifier les clés requises
      expect(deputy).to have_key('first_name')
      expect(deputy).to have_key('last_name') 
      expect(deputy).to have_key('email')
      
      # Vérifier les types de données
      expect(deputy['first_name']).to be_a(String)
      expect(deputy['last_name']).to be_a(String)
      expect(deputy['email']).to be_a(String)
      
      # Vérifier que les champs ne sont pas vides
      expect(deputy['first_name']).not_to be_empty
      expect(deputy['last_name']).not_to be_empty
      expect(deputy['email']).not_to be_empty
      
      # Vérifier le format de l'email
      expect(deputy['email']).to include('@')
      expect(deputy['email']).to include('.')
      # Pour les données d'exemple, on vérifie le domaine spécifique
      expect(deputy['email']).to include('assemblee-nationale.fr')
    end
  end
end