# frozen_string_literal: true
require_relative "yambda/version"
require_relative 'yambda/tokenizer'
require_relative 'yambda/parser'
require_relative 'yambda/environment'
require_relative 'yambda/evaluator'
require_relative 'yambda/cons'
require_relative 'yambda/runtime'
require_relative 'yambda/lambda'

require 'pry-byebug' # we're doing it LIVE

module Yambda
  class Error < StandardError; end
  # Your code goes here...

  def self.repl
    ::Yambda::Runtime.new.repl
  end
end

# ::Yambda.repl