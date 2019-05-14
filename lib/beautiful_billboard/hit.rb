class BeautifulBillboard::Hit
  @@all = []

  attr_accessor :rank, :title, :recorded_by, :last_week, :peak_position, :weeks_on_chart

  def initialize(last_week = nil, peak_position = nil, weeks_on_chart = nil)
    @last_week = last_week
    @peak_position = peak_position
    @weeks_on_chart = weeks_on_chart
    @@all << self
  end

  def self.all
    @@all
  end

  def self.new_from_hit_list(item)
    # creates new Hit objects from the list generated through the scraper
    hit = self.new.tap do |h|
      h.rank = item["data-rank"]
      h.title = item["data-title"]
      h.recorded_by = item["data-artist"]
    end

    # these below are optional attributes, not every hit in the hot 100 list has these attributes present
    check = item.css("[class*='last-week']")
    !check.empty? ? hit.last_week = check[0].text : nil

    check = item.css("[class*='weeks-at-one']")
    !check.empty? ? hit.peak_position = check[0].text : nil

    check = item.css("[class*='weeks-on-chart']")
    !check.empty? ? hit.weeks_on_chart = check[0].text : nil
  end

end
