require 'csv'
require 'date'
class Building_Violations
  attr_accessor :file
  attr_reader :building_array, :violations
  def initialize(file)
    @file = file
    @building_array = []
    @violations = {}
    @earliest = ""
    @latest = ""
  end
  # Parse through csv file into a hash which incorporates the csv headers.
  # This gives me a workable array to organize my objects.
  def parse
    CSV.foreach(@file, :headers => true) do |row|
      @building_array << row
    end
  end

  # Check for earliest and latest time passing in the date and the violation name
  def earliest_latest(date_string, name)
    item = @violations[name]
    if date_string < item[:earliest] &&
      item[:earliest] = date_string
    elsif date_string > item[:latest]
      item[:latest] = date_string
    end

  end

  # A method to give violations a total amount, earliest and latest dates
  # Goes through each line and checks for unique violations. If that violation exists, it will increase the total and
  # run the method earliest_and_latest to find earliest or latest time.
  # If it doesn't exist, then it creates one.
  def total_and_dates
    @building_array.each do |building|
      violation_name = building['violation_category']
      violation_date = building['violation_date']
      violation_callback = @violations[violation_name]
      if @violations[violation_name]
        @violations[violation_name][:total] = @violations[violation_name][:total] + 1
        earliest_latest(violation_date, violation_name)
      else
        @violations[violation_name] = {total: 1, earliest: violation_date, latest: violation_date}
      end
    end
  end

  # A method to output the results in a nice sentences
  def results
    @violations.each do |k,v|
      total = v[:total]
      earliest = DateTime.parse(v[:earliest])
      earliest_time = earliest.strftime('%I:%M:%S %p')
      latest = DateTime.parse(v[:latest])
      latest_time = latest.strftime('%I:%M:%S %p')
      if total > 1
        puts "#{k} occurred #{total} times with the earliest occurrence on #{earliest.month}-#{earliest.day}-#{earliest.year} and latest occurrence on #{latest.month}-#{latest.day}-#{latest.year}."
      else
        puts "#{k} occurred #{total} time with the earliest occurrence on #{earliest.month}-#{earliest.day}-#{earliest.year} and latest occurrence on #{latest.month}-#{latest.day}-#{latest.year}."
      end
    end
  end
end

# I decided to create this practice as a class where I can call on certain methods to execute certain functions.
# I want to give each method as little responsibility as possible.
violations = Building_Violations.new('violations-2012.csv')
violations.parse
violations.total_and_dates
violations.results
