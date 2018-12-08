require "pathname"
require "pry"
require "set"

class Node
  attr_reader :children, :metadata

  def initialize(children, metadata)
    @children = children
    @metadata = metadata
  end

  def metadata_sum
    metadata.sum + children.map(&:metadata_sum).sum
  end

  def value
    if children.empty?
      @metadata.sum
    else
      child_values = @children.map(&:value)
      @metadata.map do |index|
        index -= 1
        if index < 0 or index >= child_values.size
          0
        else
          child_values[index]
        end
      end.sum
    end
  end

  def self.parse(tokens)
    num_children = tokens.shift
    num_metadata = tokens.shift
    children = num_children.times.map { parse(tokens) }
    metadata = num_metadata.times.map { tokens.shift }
    Node.new(children, metadata)
  end
end

class Day08
  def initialize(input_file = "")
    @input_file = input_file
  end

  def input_path
    Pathname("#{__dir__}/../data/input_08#{@input_file}.txt")
  end

  def data
    @data ||= input_path.read.split.map(&:to_i)
  end

  def root_node
    unless @root_node
      @root_node = Node.parse(data.dup)
    end
  end
end
