class SearchController < ApplicationController
  def index
    unless SearchService::RESOURCES.include?(params[:resource])
      redirect_to root_path

      flash[:alert] = 'Wrong resource! Select available resource.'
    else
       @results = SearchService.call(query_params)
    end
  end

  private

  def query_params
    params.permit(:query, :resource)
  end
end
