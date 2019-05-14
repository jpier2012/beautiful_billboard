class BeautifulBillboard::Star
  @@all = []

  attr_accessor :rank, :name, :page_link, :last_week, :peak_position, :weeks_on_chart
  attr_reader :hot_hits, :hit_history, :videos, :news_stories

  # I keep these optional in case the data is missing from the artist 100 list
  def initialize(page_link = nil, last_week = nil, peak_position = nil, weeks_on_chart = nil)
    @page_link = page_link
    @last_week = last_week
    @peak_position = peak_position
    @weeks_on_chart = weeks_on_chart
    @hot_hits = []
    @hit_history = []
    @videos = []
    @news_stores = []
    @@all << self
  end

  def self.all
    @@all
  end

  def self.new_from_star_list(item)
    # creates new Star objects from the list generated through the scraper
    star = self.new.tap do |s|
      s.rank = item["data-rank"]
      s.name = item["data-title"]
    end

    # these below are optional attributes, not every artist in the artist 100 list has these attributes present
    check = item.css("[class*='title-text'] a")
    !check.empty? ? star.page_link = check[0]["href"] : nil

    check = item.css("[class*='last-week']")
    !check.empty? ? star.last_week = check[0].text : nil

    check = item.css("[class*='weeks-at-one']")
    !check.empty? ? star.peak_position = check[0].text : nil

    check = item.css("[class*='weeks-on-chart']")
    !check.empty? ? star.weeks_on_chart = check[0].text : nil
  end

  def get_hot_hits
    # shows the hits currently on the hot 100 list
    @hot_hits = self.class.all.select { |h| h.recorded_by.include?("#{self.name}")}
  end

  def get_hit_history(star_page_elements)
    # pulls the list of past chart-topping hits from the artist detail page
    star_page_elements.css(".artist-section--chart-history__title-list__title").each do |item|
      @hit_history << "#{item["data-title"]} - #{item.css("[class*='peak-rank']")[0].text.strip}"
    end
  end

  def get_videos(star_page_elements)
    # pulls the list of video links from the artist detail page
  end

  def get_news_stories(star_page_elements)
    # pulls the list of news stories from the artist detail page
  end

  def complete_details(star_page_elements)
    self.get_hot_hits
    self.get_hit_history(star_page_elements)
    self.get_videos(star_page_elements)
    self.get_hit_history(star_page_elements)
  end

end
