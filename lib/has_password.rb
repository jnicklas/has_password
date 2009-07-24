require 'digest/sha1'

module HasPassword
  
  FORBIDDEN = %w(password user system test admin)
  
  class << self
    # Returns the SHA1 hash of the string with the given salt
    def encrypt(string, salt = '')
      hashable = "----#{salt}----#{string}--"
      Digest::SHA256.hexdigest(hashable)
    end
  
    def included(base)
      super
      base.send :extend, HasPassword
    end
  end
  
  def has_password
    include HasPassword::InstanceMethods
    
    validates_format_of :password_hash, :with => /\A[0-9a-f]{64}\z/
    validates_format_of :password_salt, :with => /\A[0-9a-f]{64}\z/
    validates_confirmation_of :password
    
    define_callbacks :after_password_change

    after_update do |m|
      m.instance_eval do
        callback(:after_password_change) if password_hash_changed?
      end
    end
    
    validate do |m|
      unless m.password.blank?
        HasPassword::FORBIDDEN.each do |word|
          m.errors.add(:password, "may not contain the string '#{word}'") if
              m.password =~ Regexp.new(word, Regexp::IGNORECASE)
        end
      end
      
      m.errors.add(:password, 'must not be blank') if m.new_record? and m.password.blank?
    end
  end
  
  def salt_length
    @salt_length
  end
  
  module InstanceMethods
    # Returns the current plain-text password if it is available
    def password
      @password
    end
    
    # Sets the password to the given plain-text value
    def password=(pwd)
      return if pwd.blank?
      @password = pwd.to_s
      salt = HasPassword.encrypt(Time.now.to_i, @password)
      self.password_salt = salt
      self.password_hash = HasPassword.encrypt(@password, salt)
    end
    
    # Returns +true+ iff the user has the given password
    def has_password?(pwd)
      password_hash == HasPassword.encrypt(pwd, password_salt)
    end
  end
  
end

ActiveRecord::Base.send(:include, HasPassword) if defined?(ActiveRecord)
