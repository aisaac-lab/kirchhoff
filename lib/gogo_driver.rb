require "gogo_driver/version"
require "gogo_driver/entity"

module GogoDriver
  def go(url='https://www.google.com')
    @entity = Entity.new unless @entity
    @entity.go(url)
  end

  def method_missing(method, *args, &block)
    @entity.respond_to?(method) ? @entity.send(method, *args, &block) : super
  rescue Errno::ECONNREFUSED
    go # Remind past url ...
    @entity.send(method, *args, &block)
  end
end
