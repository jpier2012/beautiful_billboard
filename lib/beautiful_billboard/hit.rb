class BeautifulBillboard::Hit
  @@all = []

  attr_accessor :rank, :title, :last_week, :peak_position, :weeks_on_chart

  def initialize
    @@all << self
  end

  def self.all
    @@all
  end

  def self.new_from_hit_list(list)
    # creates new Hit objects from the list generated through the scraper
  end

end
