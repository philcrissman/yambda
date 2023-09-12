module Yambda
  class Cons
    attr_reader :car, :cdr

    def initialize(car, cdr)
      @car = car
      @cdr = cdr
    end

    # def to_s
    #   str = "'("
    #   c = self.car
    #   while c
    #     str += c.to_s
    #     c = c.cdr
    #   end
    # end
  end
end