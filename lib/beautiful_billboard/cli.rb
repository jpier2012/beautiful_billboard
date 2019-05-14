class BeautifulBillboard::CLI

  def initialize
    @input = ""
    @star_index = 19
  end

  def get_input
    @input = gets.strip.to_i
  end

  def intro
    top = "==============================================================="
    mid = "||        Welcome to the Beautiful Billboard CLI!            ||"
    bot = "==============================================================="
    banner = [top, mid, bot]

    i = 1
    until i == 16
      40.times do puts "\n" end
      banner.each do |e|
        puts e.light_yellow if i.odd?
        puts e.light_yellow.swap if i.even?
      end
        sleep(0.2)
        i += 1
    end
  end

  def call
    BeautifulBillboard::Scraper.create_objects
    intro
    puts "~~~~~~~~~~ Your one-stop-shop for popular music! ~~~~~~~~~~~~~~".yellow
    puts "~~~~~~~~~~~ Press enter to see the top 20 stars ~~~~~~~~~~~~~~~".white
    get_input

    list_stars(@star_index)
    start_menu
  end

  def start_menu
    puts "================================================================".yellow.bold
    puts "Would you like to see more stars or a specific star detail?".blue.bold
    puts "1) More stars!".blue
    puts "2) A specific star!".blue
    puts "0) Exit".blue
    puts "================================================================".yellow.bold
    get_input

    case @input
    when 0
      puts "Goodbye!"
      exit
    when 1
      @star_index += 20 unless @star_index >= 99
      list_stars(@star_index)
      puts "There are no more stars!".red.bold if @star_index == 99
      start_menu
    when 2
      star_detail_menu
    else
      puts "Sorry, I didn't catch that - ".red.bold
      start_menu
    end
  end

  def star_detail_menu
    puts "================================================================".yellow.bold
    puts "Please enter the number of the star you'd like to see.".cyan.bold
    puts "================================================================".yellow.bold
    get_input

    if @input == 0
      puts "Goodbye!"
      exit
    elsif @input <= 0 || @input > 100
      puts "It needs to be between 1 and 100!".red.bold
      star_detail_menu
    end

    star_details(@input - 1)
    puts "Hit any key to return to the star list."
    get_input
    list_stars(@star_index)
    start_menu
  end

  # print out the list of stars up to and including the index
  def list_stars(index)
    BeautifulBillboard::Star.all[0..index].each_with_index do |s, i|
      str = "#{s.rank}) #{s.name}"
      puts str.blue if i.odd?
      puts str.green if i.even?
    end
  end

  # print out the star details for the star listed at rank: index
  def star_details(index)
    s = BeautifulBillboard::Star.all[index]
    BeautifulBillboard::Scraper.complete_star_details(s)
    puts "----------------------------------------------------------------".blue.bold
    puts "Rank:               #{s.rank}".cyan
    puts "Name:               #{s.name}".cyan
    puts "Page Link:          https://www.billboard.com#{s.page_link}".cyan
    puts "Last Week:          #{s.last_week}".cyan
    puts "Peak Position:      #{s.peak_position}".cyan
    puts "Weeks on Chart:     #{s.weeks_on_chart}".cyan
    puts "----------------------------------------------------------------".blue.bold
    puts "Hot Hits: #{s.hot_hits.count} total".yellow
    puts "~~~~~~~~~~~~~~~~~~~~~~".blue.bold
    print_list(s.hot_hits)
    puts "Hit History: #{s.hit_history.count} total".yellow
    puts "~~~~~~~~~~~~~~~~~~~~~~".blue.bold
    print_list(s.hit_history)
    puts "Videos: #{s.videos.count} total".yellow
    puts "~~~~~~~~~~~~~~~~~~~~~~".blue.bold
    print_list(s.videos)
    puts "Articles: #{s.articles.count} total".yellow
    puts "~~~~~~~~~~~~~~~~~~~~~~".blue.bold
    print_list(s.articles)
  end

  def print_list(list)
    i = 1
    list.each do |line|
      puts "  #{i}) #{line}".cyan
      puts "~~~".blue
      i += 1
    end
  end
end
