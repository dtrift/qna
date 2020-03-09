class SearchService
  def self.find(query, resource)
    if resource == 'All'
      ThinkingSphinx.search(query)
    else
      resource.constantize.search(query)
    end 
  end
end
