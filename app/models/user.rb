class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  before_save   :downcase_email
  before_create :create_activation_digest
  validates :name,  presence: true, length: { maximum: 50 },
                    uniqueness: { case_sensitive: false }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_senstiive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  has_many :events, :foreign_key => "creator_id", dependent: :destroy
  has_many :invitations, :foreign_key => :attendee_id
  has_many :attended_events, :through => :invitations

  #Return the hash digest of the given string

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  #Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  #Remembers a user in the database for use in the persistent session
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  #Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  #Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end


  def upcoming_events
    self.attended_events.upcoming
  end

  def previous_events
    self.attended_events.past
  end

  def attending?(event)
    event.attendees.include?(self)
  end

  def attend!(event)
    self.invitations.create!(attended_event_id: event.id)
  end

  def cancel!(event)
    self.invites.find_by(attended_event_id: event.id).destroy
  end

  private

    #converts email to all lower-case
    def downcase_email
      self.email = email.downcase
    end

    #createst and assigns the activation token and digest
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end
