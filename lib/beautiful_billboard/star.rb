class BeautifulBillboard::Star
  @@all = []

  attr_accessor :rank, :name, :page_link, :last_week, :peak_position, :weeks_on_chart
  attr_reader :hit_history, :videos, :news_stories, :hot_hits

  def initialize
    @@all << self
  end

  def self.all
    @@all
  end

  def self.new_from_star_list(list)
    # creates new Star objects from the list generated through the scraper
  end

  def get_hit_history(page)
    # pulls the list of past chart-topping hits from the artist detail page
  end

  def get_videos(page)
    # pulls the list of video links from the artist detail page
  end

  def get_news_stories(page)
    # pulls the list of news stories from the artist detail page
  end

  def get_hot_hits(page)
    # shows the hits currently on the hot 100 list
  end

  def complete_details(star)
    star.get_hit_history(star.page_link)
    star.get_videos(star.page_link)
    star.get_hit_history(star.page_link)
    star.get_hot_hits(star.page_link)
  end

end
