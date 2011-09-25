class User < ActiveRecord::Base
  validates :username, :passcrypt, :email, presence: true
  validates :username, :email, uniqueness: true
  validates :passcrypt, format: {with: /[0-9a-f]{40}/}
  validates :email, format: {with: /[\w\.]+@(\w+\.)+\w+/}

  def encrypt_password
    return nil unless self.passcrypt.wordy?
    self.passcrypt = Digest::SHA1.hexdigest(self.passcrypt)
  end

  def validation_token
    Digest::SHA1.hexdigest(self.created_at.to_s)
  end

  def self.authenticate(u, p)
    return nil unless u.wordy? && p.wordy?
    first(conditions: ["username = :username AND passcrypt = :password AND validated_at", username: u, password: Digest::SHA1.hexdigest(p)])
  end

end
