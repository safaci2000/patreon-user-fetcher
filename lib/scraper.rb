require 'CSV'
module Scraper
  module Patreon
    def self.authenticate(agent)
      agent.get('http://www.patreon.com/login_i')
      form = agent.page.forms.first
      form.email = ENV['PATREON_EMAIL']
      form.password = ENV['PATREON_PASSWORD']

      form.submit form.buttons.first #return
    end

    def self.fetch_user_hash_from_csv(agent)
      agent.get('https://www.patreon.com/downloadCsv?hid=')

      hash = {
          :names => [],
          :original => CSV.parse(agent.page.body, {:headers => true}),
          :skipsies => [], # Rows with non-data in them
      }
      i = 0

      # Determine rows that need to be skipped because they have junk/non-user data.
      hash[:original]["Name"].to_a.select do |name|
        if (name.match /Reward/)
          hash[:skipsies] << i
        end
        i += 1
      end

      # Set each column of the CSV to a symbol, but filter out "skipsies"
      hash[:original].headers.each do |header_name|
        header_name.downcase!
        hash[header_name.to_sym] = []
        # Add to hash, but dont include skipsies
        hash[:original][header_name.to_s].to_a.each_with_index do |value,eq|
          unless hash[:skipsies].include? eq
            hash[header_name.to_sym] << value
          end
        end
      end

      hash #return
    end
  end
end
