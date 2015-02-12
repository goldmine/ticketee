class Ability
  include CanCan::Ability

  def initialize(user)
    user.permissions.each do |p|
      can p.action.to_sym,
          p.thing_type.constantize do |thing|
          thing.nil? || p.thing_id.nil? || p.thing_id == thing.id
      end
    end
  end
end
