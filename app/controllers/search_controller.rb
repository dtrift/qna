class SearchController < ApplicationController
  def index
    query = params[:query]
    resource = params[:resource]

    if query.blank?
      redirect_to root_path

      flash[:notice] = 'Query can\'t be blank'
    else
      @results = SearchService.find(query, resource)
    end
  end
end
