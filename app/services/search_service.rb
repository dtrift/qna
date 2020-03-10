class SearchService
  RESOURCES = %w[All Question Answer Comment User].freeze

  def self.call(params)
    if params[:resource] == 'All'
      ThinkingSphinx.search(params[:query])
    else
      params[:resource].constantize.search(params[:query])
    end 
  end
end
