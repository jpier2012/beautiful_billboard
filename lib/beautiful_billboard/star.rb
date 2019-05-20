class BeautifulBillboard::Star
  @@all = []

  attr_accessor :rank, :name, :page_link, :last_week, :peak_position, :weeks_on_chart
  attr_reader :hot_hits, :hit_history, :videos, :articles

  # attribute default values are not necessary because I set them through new.tap in self.new_from_star_list
  def initialize
    @hot_hits = []
    @hit_history = []
    @articles = []
    @videos = []
    @updated = false
    @@all << self
  end

  def self.all
    @@all
  end

  # creates new Star objects from the list items generated through the scraper
  def self.new_from_star_list(item)
    self.new.tap do |s|
      s.rank = item["data-rank"]
      s.name = item["data-title"]

      # For these, the data container may not exist on the main list page so the .css selector may return a blank array,
      # which then gives a noMethodError for the .text method called on it.
      # Assigning attributes using ||= will not work because of this error.
      # The below functions check to see if the .css selector array is empty.
      # If it is not empty, set the attribute to the text of that selector's first element,
      # otherwise set the attribute to nil.

      arr = item.css("[class*='title-text'] a")
      !arr.empty? ? s.page_link = arr[0]["href"] : s.page_link = nil

      arr = item.css("[class*='last-week']")
      !arr.empty? ? s.last_week = arr[0].text : s.last_week = nil

      arr = item.css("[class*='weeks-at-one']")
      !arr.empty? ? s.peak_position = arr[0].text : s.peak_position = nil

      arr = item.css("[class*='weeks-on-chart']")
      !arr.empty? ? s.weeks_on_chart = arr[0].text : s.weeks_on_chart = nil
    end
  end

  # shows the hits currently on the hot 100 list
  # stored as hashes instead of strings for formatting purposes in the detail display
  def get_hot_hits
    BeautifulBillboard::Hit.all.each do |h|
      @hot_hits << {"#{h.title}" => "Current Rank: #{h.rank}"} if h.recorded_by.include?("#{self.name}")
    end
  end

  # pulls the list of past chart-topping hits from the artist detail page\
  def get_hit_history(star_page_elements)
    star_page_elements.css(".artist-section--chart-history__title-list__title").each do |item|
      @hit_history << {"#{item["data-title"]}" => "#{item.css("[class*='peak-rank']")[0].text.strip}"}
    end
  end

  # pulls the list of links from the artist detail page,
  # qualifies it as a "video" or "article" based on the link
  def get_links(star_page_elements)
    star_page_elements.css("li[class*='artist-section']").each do |link|
      url = link.css("a")[0]["href"]

      if url.include?('video')
        @videos << {"#{link.text.strip}" => "#{url.strip}"}
      elsif url.include?('articles')
        @articles << {"#{link.text.strip}" => "#{url.strip}"}
      end
    end
  end

  def complete_details(star_page_elements)
    get_hot_hits
    get_hit_history(star_page_elements)
    get_links(star_page_elements)
    @updated = true
  end

  def updated?
    @updated
  end
end
