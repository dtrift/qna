class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def create
    question = Question.find(params[:question_id])
    @subscription = current_user.subscribe!(question)

    flash[:notice] = 'Subscribed successfully'
  end

  def destroy
    @subscription = Subscription.find(params[:id]).destroy

    flash[:notice] = 'Unsubscribed successfully'
  end
end
