class BeautifulBillboard::Scraper
  # creates an element array to pass to the Star class to instantiate each star
  def self.star_list
    Nokogiri::HTML(open('https://www.billboard.com/charts/artist-100')).css(".chart-list-item")
  end

  # creates an element array to pass to the Hit class to instantiate each hit
  def self.hit_list
    Nokogiri::HTML(open('https://www.billboard.com/charts/hot-100')).css(".chart-list-item")
  end

  # feeds star_list to the Star class to create stars for each list item
  def self.create_stars_from_list
    self.star_list.each do |item|
      BeautifulBillboard::Star.new_from_star_list(item)
    end
  end

  # feeds hit_list to the Hit class to create hits for each list item
  def self.create_hits_from_list
    self.hit_list.each do |item|
      BeautifulBillboard::Hit.new_from_hit_list(item)
    end
  end

  def self.create_objects
    self.create_hits_from_list
    self.create_stars_from_list
  end

  # gets the elements of the star's page_link and then feeds that data to the star object instance to update its attributes
  def self.complete_star_details(star)
    star.complete_details(Nokogiri::HTML(open("https://www.billboard.com#{star.page_link}")))
  end
end
