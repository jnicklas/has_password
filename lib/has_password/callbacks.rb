module HasPassword
  module Callbacks
  private
    
    def self.extended(base)
      base.define_callbacks :after_password_change
      base.send :after_update do |m|
        m.instance_eval do
          callback(:after_password_change) if password_hash_changed?
        end
      end
    end
    
  end
end
