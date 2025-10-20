require 'nokogiri'
require 'open-uri'

def crypto_scrapper
  url = 'https://coinmarketcap.com/all/views/all/'

  begin
    # Headers plus complets pour éviter le blocage
    headers = {
      "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
      "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
      "Accept-Language" => "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7"
    }

    puts "🔍 Accès à la page..."
    html = URI.open(url, headers)
    doc = Nokogiri::HTML(html)

    cryptos = []

    # Sélecteurs mis à jour pour la structure actuelle de CoinMarketCap
    doc.css('table tbody tr').each do |row|
      # Nom de la crypto - sélecteur plus spécifique
      name_element = row.at_css('[class*="symbol"]') || 
                    row.at_css('td:nth-child(3)') || 
                    row.at_css('td:nth-child(2) p')
      
      # Prix - sélecteur plus spécifique
      price_element = row.at_css('a[href*="/markets/"] span') ||
                     row.at_css('td:nth-child(5) span') ||
                     row.at_css('td:nth-child(4) span')

      next if name_element.nil? || price_element.nil?

      name = name_element.text.strip
      price_text = price_element.text.strip

      # Nettoyage du prix
      cleaned_price = price_text.gsub(/[^\d.,]/, '').gsub(',', '')
      price = cleaned_price.to_f

      # Filtrage des données invalides
      next if name.empty? || price <= 0

      cryptos << { name => price }
      
      # Limiter pour les tests (optionnel)
      break if cryptos.size >= 20 # Enlève cette ligne pour avoir toutes les cryptos
    end

    puts "#{cryptos.size} cryptomonnaies récupérées"
    
    # Afficher les 5 premières pour vérification
    puts "Exemple des 5 premières :"
    cryptos.first(5).each do |crypto|
      puts "  #{crypto.keys.first}: #{crypto.values.first}"
    end
    
    cryptos
    
  rescue OpenURI::HTTPError => e
    puts " Erreur HTTP : #{e.message}"
    []
  rescue SocketError => e
    puts " Pas de connexion Internet : #{e.message}"
    []
  rescue => e
    puts " Erreur inconnue : #{e.message}"
    puts "Détails: #{e.backtrace.first}"
    []
  end
end

# Version alternative avec une approche différente
def crypto_scrapper_alternative
  url = 'https://coinmarketcap.com/all/views/all/'

  begin
    headers = {
      "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
    }

    html = URI.open(url, headers)
    doc = Nokogiri::HTML(html)

    cryptos = []

    # Approche plus robuste : chercher les patterns communs
    doc.css('tr').each do |row|
      # Chercher le texte qui ressemble à un symbole crypto (3-5 lettres majuscules)
      name_match = row.text.match(/\b[A-Z]{2,5}\b/)
      next unless name_match
      
      # Chercher un prix (format $123.45)
      price_match = row.text.match(/\$\d+\.\d+/)
      next unless price_match
      
      name = name_match[0]
      price = price_match[0].gsub('$', '').to_f
      
      # Éviter les doublons et valeurs aberrantes
      unless cryptos.any? { |c| c.keys.first == name } || price <= 0
        cryptos << { name => price }
      end
    end

    puts " #{cryptos.size} cryptomonnaies récupérées (méthode alternative)"
    cryptos
    
  rescue => e
    puts "Erreur: #{e.message}"
    []
  end
end

# Test manuel
if __FILE__ == $0
  puts "=== Test du scraper crypto ==="
  result = crypto_scrapper
  puts "Résultat: #{result.size} éléments"
end