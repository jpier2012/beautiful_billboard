class BeautifulBillboard::Hit
  @@all = []

  attr_accessor :rank, :title, :recorded_by, :last_week, :peak_position, :weeks_on_chart

  def initialize(item_hash)
    item_hash.each { |k, v| self.send("#{k}=", "#{v}") }
    @@all << self
  end

  def self.all
    @@all
  end
end
