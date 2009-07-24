# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{has_password}
  s.version = "0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["James Coglan, Jonas Nicklas"]
  s.date = %q{2009-07-24}
  s.description = %q{+has_password+ is a simple password-hashing abstraction for use in ActiveRecord models.
It is designed to be as simple as possible: it deals only with password handling, not
with authentication processes, controller code, generators etc.

To use it:

  class User < ActiveRecord::Base
    has_password
  end

Your model should have +password_hash+ and +password_salt+ fields. Hashes are 256-bit
(64-char) SHA256 hashes. Your model will gain three methods:

<tt>user.password=(pwd)</tt>: sets the hash and salt values of user from the given
plain-text value pwd. The plain-text password is stored in +user+ while in memory but is
not persisted to the database.

<tt>user.password</tt> returns the current plain-text password if one has been set since
+user+ was pulled from the database. An object freshly pulled from the DB will return
+nil+ for this method.

<tt>user.has_password?(pwd)</tt>: returns true iff <tt>user</tt>’s plain-text password
is equal to +pwd+.

Finally, you get a callback in case you want to do stuff like send password confirmation
emails. In your model class, put, for example:

  after_password_change :send_notification

or

  after_password_change do |model|
    UserMailer::deliver_email_notification(model)
  end

In terms of validation, it automatically <tt>validates_confirmation_of :password</tt>
and checks supplied passwords for a few obvious silly phrases like, say, +password+ and
+test+. Passwords are only validated if +password+ is non-blank.}
  s.email = ["jonas.nicklas@gmail.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.rdoc", "Rakefile", "init.rb", "lib/has_password.rb", "script/console", "script/destroy", "script/generate", "test/fixtures/schema.rb", "test/fixtures/user.rb", "test/has_password_test.rb", "test/test_has_password.rb", "test/test_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/jnicklas/has_password}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{has_password}
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{+has_password+ is a simple password-hashing abstraction for use in ActiveRecord models}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hoe>, [">= 2.3.2"])
    else
      s.add_dependency(%q<hoe>, [">= 2.3.2"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 2.3.2"])
  end
end
