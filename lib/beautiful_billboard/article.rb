class BeautifulBillboard::Article
  @@all = []

  attr_accessor :title, :link, :star

  def initialize(item_hash)
    item_hash.each { |k, v| self.send("#{k}=", "#{v}") }
    @@all << self
  end

  def self.all
    @@all
  end
end
