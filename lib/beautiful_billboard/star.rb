class BeautifulBillboard::Star
  @@all = []

  attr_accessor :rank, :name, :page_link, :last_week, :peak_position, :weeks_on_chart, :updated
  attr_reader :hot_hits, :hit_history, :videos, :articles

  # attribute default values are not necessary because I set them through new.tap in self.new_from_star_list
  def initialize(item_hash)
    item_hash.each { |k, v| self.send("#{k}=", "#{v}") }
    @hot_hits = []
    @past_hits = []
    @articles = []
    @videos = []
    @updated = false
    @@all << self
  end

  def self.all
    @@all
  end

  # creates new Star objects from the list items generated through the scraper
  #def self.new_from_star_list(item_hash)
    # self.new.tap do |s|
      # s.rank = item["data-rank"]
      # s.name = item["data-title"]
      #
      # # For these, the data container may not exist on the main list page so the .css selector may return a blank array,
      # # which then gives a noMethodError for the .text method called on it.
      # # Assigning attributes using ||= will not work because of this error.
      # # The below functions check to see if the .css selector array is empty.
      # # If it is not empty, set the attribute to the text of that selector's first element,
      # # otherwise set the attribute to nil.
      #
      # arr = item.css("[class*='title-text'] a")
      # !arr.empty? ? s.page_link = arr[0]["href"] : s.page_link = nil
      #
      # arr = item.css("[class*='last-week']")
      # !arr.empty? ? s.last_week = arr[0].text : s.last_week = nil
      #
      # arr = item.css("[class*='weeks-at-one']")
      # !arr.empty? ? s.peak_position = arr[0].text : s.peak_position = nil
      #
      # arr = item.css("[class*='weeks-on-chart']")
      # !arr.empty? ? s.weeks_on_chart = arr[0].text : s.weeks_on_chart = nil
    # end
  #end

  def get_hot_hits
    @hot_hits = BeautifulBillboard::HotHit.all.select { |h| h.recorded_by.include?("#{@name}")}
  end

  def get_past_hits
    @past_hits = BeautifulBillboard::PastHit.all.select do |h|
      h.star == self

      binding.pry
    end
  end

  def get_videos
    @videos = BeautifulBillboard::Video.all.select { |v| v.star == self }
  end

  def get_articles
    @articles = BeautifulBillboard::Article.all.select { |a| a.star == self }
  end

  def updated?
    @updated
  end
end
