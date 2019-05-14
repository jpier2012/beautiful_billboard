class BeautifulBillboard::CLI

  def initialize
    @input = ""
    @index = 19
  end

  def get_input
    @input = gets.strip.to_i
  end

  def call
    # call Scraper to pull data from web pages
    BeautifulBillboard::Scraper.create_stars_from_list
    BeautifulBillboard::Scraper.create_hits_from_list
    # print welcome message
    start_menu
  end

  def start_menu
    #provides the basis of the menu
    puts "Welcome to the Beautiful Billboard CLI!"
    puts "Press enter to see the top 20 stars"
    puts "Type 0 (Zero) at anytime to exit"

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
    star_details(@index)
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
    puts "XXXXXX This is list_stars"
    BeautifulBillboard::Star.all[0..@index].each do |s|
      puts "#{s.rank}) #{s.name}"
    end
  end

  def star_details(index)
    # print out the star details for the star listed at rank: index
    puts "XXXXXX This is star_details"
    s = BeautifulBillboard::Star.all[@index]
    BeautifulBillboard::Scraper.complete_star_details(s)
    puts "Rank: #{s.rank}"
    puts "Name: #{s.name}"
    puts "Page Link: #{s.page_link}"
    puts "Last Week: #{s.last_week}"
    puts "Peak Position: #{s.peak_position}"
    puts "Weeks on Chart: #{s.weeks_on_chart}"
    puts "Hot Hits: #{s.hot_hits}"
    puts "Hit History: #{s.hit_history}"
    puts "Videos: #{s.videos}"
    puts "News Stories: #{s.news_stories}"
  end
end
