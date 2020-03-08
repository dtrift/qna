class SearchController < ApplicationController
  def index
    @results = ThinkingSphinx.search(params[:query])
  end

  private

  def search_params
    params.permit(:query, :commit)
  end
end
