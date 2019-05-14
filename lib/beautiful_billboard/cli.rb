class BeautifulBillboard::CLI

  def initialize
    @input = ""
    @index = 19
  end

  def get_input
    @input = gets.strip.to_i
  end

  def call
    BeautifulBillboard::Scraper.create_objects
    puts "Welcome to the Beautiful Billboard CLI!"
    puts "Press enter to see the top 20 stars"
    get_input
    list_stars(@index)
    star_or_detail_menu
  end

  def star_or_detail_menu
    puts "Would you like to see more stars or a specific star detail?"
    puts "1) More stars!"
    puts "2) A specific star!"
    puts "0) Exit"
    # 1) "More stars!" adds 20 more stars
      # list_stars index + 20
    # 2) Star detail!
    get_input
    case @input
    when 0
      puts "Goodbye!"
      exit
    when 1
      @index += 20 unless @index >= 99
      list_stars(@index)
      puts "You're seeing all the stars!" if @index == 99
      star_or_detail_menu
    when 2
      star_detail_menu
    else
      puts "Sorry, I didn't catch that - "
      star_or_detail_menu
    end
  end

  def star_detail_menu
    # loop this menu
    puts "Please enter the number of the star you'd like to see"
    get_input
    star_details(@input - 1)
    star_detail_or_list_menu
  end

  def star_detail_or_list_menu
    puts "Would you like to see another star or go back to the list view?"
    puts "1) Another star!"
    puts "2) The list view!"
    puts "0) Exit"
    get_input
    case @input
    when 0
      puts "Goodbye!"
      exit
    when 1
      star_detail_menu
    when 2
      list_stars(@index)
      star_or_detail_menu
    else
      puts "Sorry, I didn't catch that - "
      star_detail_or_list_menu
    end
  end

  def list_stars(index)
    # print out the list of stars up to and including the index
    BeautifulBillboard::Star.all[0..index].each do |s|
      puts "#{s.rank}) #{s.name} / #{s.page_link}"
    end
  end

  def star_details(index)
    # print out the star details for the star listed at rank: index
    s = BeautifulBillboard::Star.all[index]
    BeautifulBillboard::Scraper.complete_star_details(s)
    puts "Rank:               #{s.rank}"
    puts "Name:               #{s.name}"
    puts "Page Link:          #{s.page_link}"
    puts "Last Week:          #{s.last_week}"
    puts "Peak Position:      #{s.peak_position}"
    puts "Weeks on Chart:     #{s.weeks_on_chart}"
    print_hot_hits(s)
    print_hit_history(s)
    print_news_stories(s)
  end

  def print_hot_hits(star)
    i = 1
    puts "Hot Hits: #{star.hot_hits.count} total"
    star.hot_hits.each do |hit|
      puts "#{i}) #{hit.title} - #{hit.recorded_by} / Current Rank: #{hit.rank}"
      i += 1
    end
  end

  def print_hit_history(star)
    i = 1
    puts "Hit History: #{star.hit_history.count} total"
    star.hit_history.each do |hit|
      puts "#{i}) #{hit}"
      i += 1
    end
  end

  def print_news_stories(star)
    i = 1
    puts "News Stories: #{star.news_stories.count} total"
    star.news_stories.each do |story|
      puts "#{i}) #{story}"
      i += 1
    end
  end
end
