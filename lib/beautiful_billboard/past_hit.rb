class BeautifulBillboard::PastHit
  @@all = []

  attr_accessor :title, :past_peak, :star

  def initialize(item_hash)
    item_hash.each { |k, v| self.send("#{k}=", "#{v}") }
    @@all << self
  end

  def self.all
    @@all
  end
end
