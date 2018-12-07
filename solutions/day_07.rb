require "pathname"
require "pry"
require "set"

class Day07
  def initialize(input_file = "")
    @input_file = input_file
  end

  def input_path
    Pathname("#{__dir__}/../data/input_07#{@input_file}.txt")
  end

  def data
    @data ||= begin
      input_path.readlines.map do |line|
        line =~ /Step (.) must be finished before step (.) can begin/ or raise
        [$1, $2]
      end
    end
  end

  def dependencies
    @dependencies ||= data.group_by(&:last).transform_values { |x| x.map(&:first).to_set }
  end

  def steps
    @steps ||= data.flatten.uniq.sort
  end
end
