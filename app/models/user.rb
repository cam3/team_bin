class User < ActiveRecord::Base
  attr_accessor :from_omniauth, :login
  validates :username,
  :uniqueness => {
    :case_sensitive => false
  }

  has_many :identities
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
    :recoverable, :rememberable, :trackable, :validatable,
    :confirmable

  def self.from_omniauth(auth, current_user = nil)
    identity = Identity.find_or_create_for_omniauth(auth)

    # If a current_user is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = current_user ? current_user : identity.user

    # Create the user if needed
    if user.nil?
      user = where(email: auth.email).first_or_create do |user|
        user.email    = auth.email         if auth.email
        user.username = auth.info.nickname if auth.info.nickname
      end
    end

    # Associate the identity with the user if needed
    #if user && identity.user != user
    #  identity.user = user
    #  identity.save!
    #end

    user.from_omniauth = true
    user
  end

  def self.new_with_session(params, session)
    logger.debug session["devise.user_attributes"].inspect
    if session["devise.user_attributes"]
      user = super
      user.from_omniauth = true
      identity = Identity.find_or_create_for_omniauth(session["devise.user_attributes"])

      if user && identity.user != user
        identity.user = user
        identity.save!
      end
      #new(session["devise.user_attributes"], without_protection: true) do |user|
      #  user.attributes = params
      #  user.valid?
      #end
      user
    else
      super
    end
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def password_required?
    # The password is only required if they are registering without an identity aka openid or oauth via omniauth
    super && identities.empty? && !from_omniauth
  end
end
