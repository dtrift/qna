class SearchService
  RESOURCES = %w[All Question Answer Comment User].freeze

  def self.call(query, resource)
    resource_valid?(resource) ? run_search(query, resource) : exception_invalid_resource
  end

  private

  def self.resource_valid?(resource)
    RESOURCES.include?(resource)
  end

  def self.run_search(query, resource)
    resource == 'All' ? ThinkingSphinx.search(query) : resource.constantize.search(query)
  end

  def self.exception_invalid_resource
    raise StandardError, 'Wrong resource! Select available resource.'
  end
end
