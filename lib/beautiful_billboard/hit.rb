class BeautifulBillboard::Hit
  @@all = []

  attr_accessor :rank, :title, :recorded_by, :last_week, :peak_position, :weeks_on_chart

  def initialize
    @@all << self
  end

  def self.all
    @@all
  end

  # creates new Hit objects from the list generated through the scraper
  def self.new_from_hit_list(item)
    self.new.tap do |h|
      h.rank = item["data-rank"]
      h.title = item["data-title"]
      h.recorded_by = item["data-artist"]

      # same case as with Star class, these below are optional attributes, not every hit in the hot 100 list has these present
      arr = item.css("[class*='last-week']")
      !arr.empty? ? h.last_week = arr[0].text : h.last_week = nil

      arr = item.css("[class*='weeks-at-one']")
      !arr.empty? ? h.peak_position = arr[0].text : h.peak_position = nil

      arr = item.css("[class*='weeks-on-chart']")
      !arr.empty? ? h.weeks_on_chart = arr[0].text : h.weeks_on_chart = nil
    end
  end
end
