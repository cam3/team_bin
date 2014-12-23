class User < ActiveRecord::Base
  attr_accessor :from_omniauth, :login
  validates :username, presence: true,
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

    ## Some of this seems redundtant right now, but that is so it's easy to change behavior down the road
    if current_user && identity.user && current_user != identity.user
      # If both the user and identity exist but there is a mismatch, just
      # associate the identity with the user who is already logged in.
      identity.user = current_user
      identity.save!
      return current_user
    elsif current_user && identity.user && current_user == identity.user
      # If current user and identity match, just return the user. This is
      # simply a returning customer :)
      return current_user
    elsif current_user && identity.user.nil?
      # If the user exists and the identity is new, associate the identity
      # with the user who is already logged in.
      identity.user = current_user
      identity.save!
      return current_user
    elsif current_user.nil? && identity.user
      # If they're not currently signed in and the identity exists just return
      # the user, this is simply a returning customer :)
      return identity.user
    elsif current_user.nil? && identity.user.nil?
      user = where(email: auth.email).first_or_create do |user|
        user.email    = auth.email         if auth.email
        user.username = auth.info.nickname if auth.info.nickname
      end
    else
      logger.error("I can't think of a single reason why we're inside this else block... look into this ASAP.")
    end

    user
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      user = super
      # unfortunately this is required so we don't ask the user for their password
      user.from_omniauth = true
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

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end
end
