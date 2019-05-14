class BeautifulBillboard::CLI

  def initialize
    @input = ""
    @index = 19
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
    puts "~~~~~~~~~~ Your one-stop-shop for popular music! ~~~~~~~~~~~~~~".light_yellow
    puts "~~~~~~~~~~~ Press enter to see the top 20 stars ~~~~~~~~~~~~~~~".light_white
    get_input

    list_stars(@index)
    start_menu
  end

  def start_menu
    puts "================================================================".light_yellow.bold
    puts <<-M.gsub(/^\s*/, '').gsub(/\s*$/, '').cyan
    Would you like to see more stars or a specific star detail?
    1) More stars!
    2) A specific star!
    0) Exit
    M
    puts "================================================================".light_yellow.bold
    get_input

    case @input
    when 0
      puts "Goodbye!"
      exit
    when 1
      @index += 20 unless @index >= 99
      list_stars(@index)
      puts "You're seeing all the stars!".light_red.bold if @index == 99
      start_menu
    when 2
      star_detail_menu
    else
      puts "Sorry, I didn't catch that - ".light_red.bold
      start_menu
    end
  end

  def star_detail_menu
    puts "================================================================".yellow.bold
    puts "Please enter the number of the star you'd like to see.".cyan
    puts "================================================================".yellow.bold
    get_input

    if @input <= 0 || @input >= 99
      puts "Please enter a valid number next time!".light_red.bold
      star_detail_menu
    end

    star_details(@input - 1)
    star_detail_or_list_menu
  end

  def star_detail_or_list_menu
    puts "================================================================".yellow.bold
    puts <<-M.gsub(/^\s*/, '').gsub(/\s*$/, '').cyan
    Would you like to see another star or go back to the list view?
    1) Another star!
    2) The list view!
    0) Exit
    M
    puts "================================================================".yellow.bold
    get_input

    case @input
    when 0
      puts "Goodbye!"
      exit
    when 1
      star_detail_menu
    when 2
      list_stars(@index)
      start_menu
    else
      puts "Sorry, I didn't catch that - "
      star_detail_or_list_menu
    end
  end

  # print out the list of stars up to and including the index
  def list_stars(index)
    BeautifulBillboard::Star.all[0..index].each do |s|
      puts "#{s.rank}) #{s.name} / #{s.page_link}"
    end
  end

  # print out the star details for the star listed at rank: index
  def star_details(index)
    s = BeautifulBillboard::Star.all[index]
    BeautifulBillboard::Scraper.complete_star_details(s)
    puts "----------------------------------------------------------------".light_white.bold
    puts <<-M.gsub(/^\s*/, '').gsub(/\s*$/, '').cyan
    puts "Rank:               #{s.rank}"
    puts "Name:               #{s.name}"
    puts "Page Link:          #{s.page_link}"
    puts "Last Week:          #{s.last_week}"
    puts "Peak Position:      #{s.peak_position}"
    puts "Weeks on Chart:     #{s.weeks_on_chart}"
    M
    puts "----------------------------------------------------------------".light_white.bold
    puts "Hot Hits: #{s.hot_hits.count} total".
    print_hot_hits(s)
    puts "Hit History: #{s.hit_history.count} total"
    print_list(s.hit_history)
    puts "Videos: #{s.videos.count} total"
    print_list(s.videos)
    puts "News Stories: #{s.articles.count} total"
    print_list(s.articles)
  end

  def print_hot_hits(star)
    i = 1
    star.hot_hits.each do |hit|
      puts "  #{i}) #{hit.title} - #{hit.recorded_by} / Current Rank: #{hit.rank}"
      i += 1
    end
  end

  def print_list(list)
    i = 1
    list.each do |line|
      puts "  #{i}) #{line}"
      i += 1
    end
  end
end
