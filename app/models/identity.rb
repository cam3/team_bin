class Identity < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  def self.find_or_create_for_omniauth(auth)
    if Hash === auth
      uid      = auth['uid']
      provider = auth['provider']
    elsif OmniAuth::AuthHash
      uid     = auth.uid
      provider = auth.provider
    end
    logger.debug("auth class: #{auth.class}")
    logger.debug("auth inspect: #{auth.inspect}")
    find_or_create_by(uid: uid, provider: provider)
  end
end
