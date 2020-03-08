class SearchController < ApplicationController
  def index
    @results = finds
  end

  private

  def finds
    query = params[:query]
    resource = params[:resource]

    if resource == 'All'
      ThinkingSphinx.search(query)
    else
      resource.constantize.search(query)
    end
  end
end
