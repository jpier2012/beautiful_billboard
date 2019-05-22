class BeautifulBillboard::Star
  @@all = []

  attr_accessor :rank, :name, :page_link, :last_week, :peak_position, :weeks_on_chart, :updated
  attr_reader :hot_hits, :past_hits, :videos, :articles

  # attribute default values are not necessary because I set them through new.tap in self.new_from_star_list
  def initialize(item_hash)
    item_hash.each { |k, v| self.send("#{k}=", v) }
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

  def get_hot_hits
    @hot_hits = BeautifulBillboard::HotHit.all.select { |h| h.recorded_by.include?("#{@name}")}
  end

  def get_past_hits
    @past_hits = BeautifulBillboard::PastHit.all.select { |h| h.star == self }
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
