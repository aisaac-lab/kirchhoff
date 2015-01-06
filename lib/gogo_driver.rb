require "gogo_driver/version"
require "gogo_driver/entity"

class GogoDriver
  attr_accessor :entity

  def initialize(url='https://www.google.com')
    @entity = Entity.new
    @entity.go(url)
    @last_url = url
  end

  def method_missing(method, *args, &block)
    @entity.respond_to?(method) ? @entity.send(method, *args, &block) : super
  rescue Errno::ECONNREFUSED
    initialize(@last_url)
    @entity.send(method, *args, &block)
  end
end
