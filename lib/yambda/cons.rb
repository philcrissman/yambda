module Yambda
  class Cons
    attr_reader :car, :cdr

    def initialize(car, cdr=nil)
      @car = car
      @cdr = cdr
    end

    def to_s
      # binding.pry
      str = "'("
      c = self
      while c
        str += c.car.to_s
        str += " " unless c.cdr.nil?
        c = c.cdr
      end
      str += ")"
      str
    end
  end
end