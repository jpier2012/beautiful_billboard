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
      hash = {
        rank: item["data-rank"],
        name: item["data-title"]
      }

      arr = item.css("[class*='title-text'] a")
      !arr.empty? ? hash[:page_link] = arr[0]["href"] : nil

      arr = item.css("[class*='last-week']")
      !arr.empty? ? hash[:last_week] = arr[0].text : nil

      arr = item.css("[class*='weeks-at-one']")
      !arr.empty? ? hash[:peak_position] = arr[0].text : nil

      arr = item.css("[class*='weeks-on-chart']")
      !arr.empty? ? hash[:weeks_on_chart] = arr[0].text : nil

      BeautifulBillboard::Star.new(hash)
    end
  end

  # gets the elements of the star's own page held in page_link
  def self.star_page_link(star)
    Nokogiri::HTML(open("https://www.billboard.com#{star.page_link}"))
  end

  def self.get_hit_history(star)
    star_page_link(star).css(".artist-section--chart-history__title-list__title").each do |item|
      star.hit_history << {"#{item["data-title"]}" => "#{item.css("[class*='peak-rank']")[0].text.strip}"}
    end
  end

  def self.create_articles_and_videos(star)
    star_page_link(star).css("li[class*='artist-section']").each do |link|
      url = link.css("a")[0]["href"]

      if url.include?('video')
        BeautifulBillboard::Video.new.tap do |v|
          v.title = link.text.strip
          v.link = url.strip
          v.star = star
        end
      elsif url.include?('articles')
        BeautifulBillboard::Article.new.tap do |a|
          a.title = link.text.strip
          a.link = url.strip
          a.star = star
        end
      end
    end
  end

  def self.complete_star_details(star)
    get_hit_history(star)
    create_articles_and_videos(star)
    star.updated = true
  end

  # feeds hit_list to the Hit class to create hits for each list item
  def self.create_hits_from_list
    self.hit_list.each do |item|
      hash = {
        rank: item["data-rank"],
        title: item["data-title"],
        recorded_by: item["data-artist"]
      }

      arr = item.css("[class*='last-week']")
      !arr.empty? ? hash[:last_week] = arr[0].text : nil

      arr = item.css("[class*='weeks-at-one']")
      !arr.empty? ? hash[:peak_position] = arr[0].text : nil

      arr = item.css("[class*='weeks-on-chart']")
      !arr.empty? ? hash[:weeks_on_chart] = arr[0].text : nil

      BeautifulBillboard::Hit.new(hash)
    end
  end

  def self.create_objects
    self.create_hits_from_list
    self.create_stars_from_list
  end
end
