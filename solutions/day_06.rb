#!/usr/bin/env ruby

require "pathname"
require "pry"
require "set"

class Day06
  def initialize(input_file = "")
    @input_file = input_file
  end

  def point_indexes
    @point_indexes ||= [*0...points.size]
  end

  def input_path
    Pathname("#{__dir__}/../data/input_06#{@input_file}.txt")
  end

  def points
    @points ||= begin
      input_path.read.lines.map { |line| line.split(", ").map(&:to_i) }
    end
  end

  def closest_point(x, y)
    distances = points.map do |xx, yy|
      (xx - x).abs + (yy - y).abs
    end
    min_distance = distances.min
    all_closest = point_indexes.select { |i| distances[i] == min_distance }
    if all_closest.size == 1
      all_closest[0]
    end
  end

  def bounds
    @bounds ||= begin
      x0, x1 = points.map(&:first).minmax
      y0, y1 = points.map(&:last).minmax
      [(x0..x1), (y0..y1)]
    end
  end

  def infinite_points
    @infinite_points ||= begin
      result = Set[]
      bounds[0].each do |x|
        result << closest_point(x, -1_000_000)
        result << closest_point(x, +1_000_000)
      end
      bounds[1].each do |y|
        result << closest_point(-1_000_000, y)
        result << closest_point(+1_000_000, y)
      end
      result - Set[nil]
    end
  end

  def counts_in_box(xs, ys)
    counts = Hash.new(0)
    xs.each do |x|
      ys.each do |y|
        pt = closest_point(x, y)
        counts[pt] += 1 if pt
      end
    end
    counts
  end

  def present_on_boundary(xs, ys)
    result = Set[]
    xs.each do |x|
      result << closest_point(x, ys.first)
      result << closest_point(x, ys.last)
    end
    ys.each do |y|
      result << closest_point(xs.first, y)
      result << closest_point(xs.last, y)
    end
    result - Set[nil]
  end

  def distance_sum(x, y)
    distances = points.map do |xx, yy|
      (xx - x).abs + (yy - y).abs
    end
    distances.sum
  end
end
