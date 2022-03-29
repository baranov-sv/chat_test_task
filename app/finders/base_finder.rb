class BaseFinder
  def initialize(scope:, params:)
    @scope = scope
    @params = params
  end

  attr_reader :scope, :params

  def execute
    scope ? scope.to_a || []
  end
end
