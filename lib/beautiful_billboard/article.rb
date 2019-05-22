class BeautifulBillboard::Article
  @@all = []

  attr_accessor :title, :link, :star

  def initialize
    @@all << self
  end

  def self.all
    @@all
  end
end
