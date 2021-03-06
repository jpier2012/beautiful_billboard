class BeautifulBillboard::CLI

  def initialize
    @input = ""
    # @star_index is to 'remember' the index at which the star_list is last called
    @star_index = 19
  end

  def get_input
    @input = gets.strip
    if /\D/.match(@input) || @input == "" || @input.to_i > 100
      puts "Please enter a valid input!".red.bold
      get_input
    end
    @input = @input.to_i
  end

  # just for fun
  def intro
    top = "==============================================================="
    mid = "||        Welcome to the Beautiful Billboard CLI!            ||"
    bot = "==============================================================="
    banner = [top, mid, bot]

    i = 1
    until i == 16
      40.times do puts "" end
      banner.each do |e|
        puts e.yellow if i.odd?
        puts e.yellow.swap if i.even?
      end
        sleep(0.2)
        i += 1
    end
  end

  def call
    BeautifulBillboard::Scraper.create_objects
    intro
    puts "~~~~~~~~~~ Your one-stop-shop for popular music! ~~~~~~~~~~~~~~".yellow
    puts "~~~~~~~~~~~ Press enter to see the top 20 stars ~~~~~~~~~~~~~~~".yellow
    gets

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
      puts "Goodbye!".red.bold
      exit
    when 1
      # Add 20 to the @star_index unless it's maxed out at 99 (the last element of the star list)
      @star_index += 20 unless @star_index >= 99
      list_stars(@star_index)
      puts "There are no more stars!".red.bold if @star_index == 99
      start_menu
    when 2
      star_detail_menu
    else
      puts "That's not a valid menu option.".red.bold
      start_menu
    end
  end

  def star_detail_menu
    puts "================================================================".yellow.bold
    puts "Please enter a number 1 - 100 for the star you'd like to see.".blue.bold
    puts "================================================================".yellow.bold
    get_input

    if @input == 0
      puts "Goodbye!".red.bold
      exit
    end

    star_details(@input - 1)
    puts "Hit any key to return to the star list.".yellow
    gets

    list_stars(@star_index)
    start_menu
  end

  # print out the list of stars up to and including the index
  def list_stars(index)
    table = TTY::Table.new(header: ["Rank", "Name", "Last Week", "Peak Position", "Weeks on Chart"])
    BeautifulBillboard::Star.all[0..index].each do |s|
      table << ["#{s.rank}", "#{s.name}", "#{s.last_week}", "#{s.peak_position}", "#{s.weeks_on_chart}"]
    end
    puts table.render(:ascii, alignments: Array.new(5, :center)).blue
  end

  # print out the star details for the star listed at index
  def star_details(index)
    s = BeautifulBillboard::Star.all[index]
    # makes sure to only scrape each artist page once in case someone re-loads an artist detail
    BeautifulBillboard::Scraper.complete_star_details(s) unless s.updated?
    puts "----------------------------------------------------------------".blue.bold
    puts "Name:".yellow.bold + "                 #{s.name}"
    puts "Rank:".yellow.bold + "                 #{s.rank}"
    puts "Page Link:".yellow.bold + "            https://www.billboard.com#{s.page_link}"
    puts "Last Week:".yellow.bold + "            #{s.last_week}"
    puts "Peak Position:".yellow.bold + "        #{s.peak_position}"
    puts "Weeks on Chart:".yellow.bold + "       #{s.weeks_on_chart}"
    puts "----------------------------------------------------------------".blue.bold

    puts "Hot Hits: #{s.get_hot_hits.count} total".yellow.bold
    puts "~~~~~~~~~~~~~~~~~~~~~~".blue.bold
    s.get_hot_hits.each_with_index do |h, i|
      puts "  #{i + 1}) #{h.title}"
      puts "     Current Rank: #{h.rank}\n".blue
    end

    puts "Past Hits: #{s.get_past_hits.count} total".yellow.bold
    puts "~~~~~~~~~~~~~~~~~~~~~~".blue.bold
    s.get_past_hits.each_with_index do |h, i|
      puts "  #{i + 1}) #{h.title}"
      puts "     #{h.past_peak}\n".blue
    end

    def puts_each(collection)
      puts "~~~~~~~~~~~~~~~~~~~~~~".blue.bold
      collection.each_with_index do |e, i|
        puts "  #{i + 1}) #{e.title}"
        puts "     #{e.link}\n".blue
      end
    end

    puts "Videos: #{s.get_videos.count} total".yellow.bold
    puts_each(s.get_videos)

    puts "Articles: #{s.get_articles.count} total".yellow.bold
    puts_each(s.get_articles)
  end
end
