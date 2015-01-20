class NumberSet
  include Enumerable

  def initialize
    @set = []
  end

  def each
    return to_enum(:each) unless block_given?
    @set.each { |number| yield number }
  end

  def <<(number)
    @set << number unless @set.include? number
  end

  def size
    @set.size
  end

  def empty?
    @set.empty?
  end

  def [](filter)
    NumberSet.new.tap do |number_set|
      each { |number| filter.persists?(number) && number_set << number }
    end
  end
end

class Filter
  def initialize(&block)
    @block = block
  end

  def persists?(number)
    @block.call(number)
  end

  def &(other)
    Filter.new { |number| persists?(number) && other.persists?(number) }
  end

  def |(other)
    Filter.new { |number| persists?(number) || other.persists?(number) }
  end
end

class TypeFilter < Filter
  def initialize(type)
    case type
      when :integer then super() { |number| number.is_a?(Integer) }
      when :complex then super() { |number| number.is_a?(Complex) }
      else super() { |n| n.is_a?(Float) || n.is_a?(Rational) }
    end
  end
end

class SignFilter < Filter
  def initialize(sign)
    case sign
      when :positive     then super() { |number| number > 0 }
      when :non_positive then super() { |number| number <= 0 }
      when :negative     then super() { |number| number < 0 }
      when :non_negative then super() { |number| number >= 0 }
    end
  end
end