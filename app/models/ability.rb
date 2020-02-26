class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user 
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  private

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer], user_id: user.id

    can :positive, [Question, Answer], voteable: { user_id: !user.id }
    can :negative, [Question, Answer], voteable: { user_id: !user.id }
    can :revote, [Question, Answer], voteable: { user_id: !user.id }
    
    can :best, Answer, question: { user_id: user.id }
    can :manage, Link, linkable: { user_id: user.id }
    can :manage, ActiveStorage::Attachment do |attachment|
      user.author? attachment.record
    end
  end
end
