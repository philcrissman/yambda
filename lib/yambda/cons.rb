module Yambda
  class EmptyList
    def list?
      true
    end

    def pair?
      false
    end

    def nil?
      true
    end
    def to_s
      "'()"
    end

    def to_a
      []
    end
  end

  class Cons
    attr_reader :car, :cdr

    def initialize(car, cdr=nil)
      @car = car
      if cdr == "'()" || cdr.nil?
        cdr = ::Yambda::EmptyList.new
      end
      @cdr = cdr
    end

    def list?(cons = self)
      if cdr.respond_to?(:list?)
        self.cdr.list?
      else
        false
      end
    end

    def pair?
      true
    end

    def to_a
      arr = []
      lst = self
      until lst.nil?
        if !lst.respond_to?(:car)
          arr << lst
        elsif lst.car.respond_to?(:list?)
          arr << lst.car.to_a
        else
          arr << lst.car
        end
        lst = lst.respond_to?(:cdr) ? lst.cdr : nil
      end
      arr
    end

    def to_s
      "'" + self.to_a.to_s.gsub("[", "(").gsub("]", ")").gsub(", ", " ")
    end
  end
end