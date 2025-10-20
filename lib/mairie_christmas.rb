require 'nokogiri'
require 'open-uri'

def get_townhall_email(townhall_url)
  begin
    puts "Scraping: #{townhall_url}"
    
    html = URI.open(townhall_url, 
      'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
    ).read
    doc = Nokogiri::HTML(html)
    
    # Chercher l'email dans tout le texte de la page
    full_text = doc.text
    email_match = full_text.match(/\b[\w\.-]+@[\w\.-]+\.\w+\b/)
    
    if email_match
      email = email_match[0]
      puts "Email trouvé: #{email}"
      email
    else
      puts "Aucun email trouvé"
      nil
    end
    
  rescue StandardError => e
    puts "Erreur: #{e.message}"
    nil
  end
end

def get_townhall_urls
  begin
    base_url = "http://annuaire-des-mairies.com/"
    val_doise_url = "#{base_url}val-d-oise.html"
    
    puts "Récupération des URLs des mairies du Val d'Oise..."
    html = URI.open(val_doise_url).read
    doc = Nokogiri::HTML(html)
    
    towns = []
    doc.css('a.lientxt').each do |link|
      town_name = link.text
      town_path = link['href']
      # Correction du format de l'URL
      town_url = town_path.start_with?('http') ? town_path : "#{base_url}#{town_path}"
      towns << { name: town_name, url: town_url }
    end
    
    puts "#{towns.count} villes trouvées"
    towns
    
  rescue StandardError => e
    puts "Erreur lors de la récupération des URLs: #{e.message}"
    []
  end
end

# Méthode pour tester manuellement
def test_email_scraping
  puts "=== Test de scraping d'emails ==="
  test_urls = [
    "http://annuaire-des-mairies.com/95/avernes.html",
    "http://annuaire-des-mairies.com/95/ableiges.html"
  ]
  
  test_urls.each do |url|
    puts "Testing: #{url}"
    email = get_townhall_email(url)
    puts "Result: #{email || 'NOT FOUND'}"
    puts "---"
  end
end

def test_urls_scraping
  puts "=== Test de récupération des URLs ==="
  towns = get_townhall_urls
  puts "Premières villes:"
  towns.first(3).each do |town|
    puts " - #{town[:name]}: #{town[:url]}"
  end
end

# Exécution des tests si le fichier est appelé directement
if __FILE__ == $0
  test_email_scraping
  puts "\n"
  test_urls_scraping
end