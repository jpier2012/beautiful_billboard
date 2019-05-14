class BeautifulBillboard::Scraper
  def self.get_elements(url)
    Nokogiri::HTML(open(url))
  end

  def self.get_list_items(url)
    self.get_elements(url).css(".chart-list-item")
  end

  # creates an array to pass to the Star class to instantiate each star
  def self.star_list
    self.get_list_items('https://www.billboard.com/charts/artist-100')
  end

  # creates an array to pass to the Hit class to instantiate each hit
  def self.hit_list
    self.get_list_items('https://www.billboard.com/charts/hot-100')
  end

  def self.create_stars_from_list
    # feeds star_list to the Star class to create stars for each list item
    self.star_list.each do |item|
      BeautifulBillboard::Star.new_from_star_list(item)
    end
  end

  def self.create_hits_from_list
    # feeds hit_list to the Hit class to create hits for each list item
    self.hit_list.each do |item|
      BeautifulBillboard::Hit.new_from_hit_list(item)
    end
  end

  def self.create_objects
    self.create_hits_from_list
    self.create_stars_from_list
  end

  def self.complete_star_details(star)
    star.complete_details(self.get_elements("https://www.billboard.com#{star.page_link}"))
  end

end
