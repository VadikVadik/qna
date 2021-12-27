# frozen_string_literal: true

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

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer]
    can :update, [Question, Answer, Comment], author_id: user.id
    can :destroy, [Question, Answer, Comment], author_id: user.id
    can :create_comment, [Question, Answer]
    can :vote, [Question, Answer]
    cannot :vote, [Question, Answer], author_id: user.id
    can :unvote, [Question, Answer], user_id: user.id
    can :subscribe, Question
    can :unsubscribe, Question do |question|
      question.subscribers.include?(user)
    end
  end
end
