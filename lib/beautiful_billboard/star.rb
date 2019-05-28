class BeautifulBillboard::Star
  @@all = []

  attr_accessor :rank, :name, :page_link, :last_week, :peak_position, :weeks_on_chart, :updated

  def initialize(item_hash)
    item_hash.each { |k, v| self.send("#{k}=", v) }
    @updated = false
    @@all << self
  end

  def self.all
    @@all
  end

  def get_hot_hits
    BeautifulBillboard::HotHit.all.select { |h| h.recorded_by.include?("#{@name}")}
  end

  def get_past_hits
    BeautifulBillboard::PastHit.all.select { |h| h.star == self }
  end

  def get_videos
    BeautifulBillboard::Video.all.select { |v| v.star == self }
  end

  def get_articles
    BeautifulBillboard::Article.all.select { |a| a.star == self }
  end

  def updated?
    @updated
  end
end
