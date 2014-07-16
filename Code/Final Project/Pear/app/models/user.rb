class User < ActiveRecord::Base
  require 'net/ldap'

  has_many :matches
  has_many :lunches, through: :matches
  has_many :openings

  before_create :create_remember_token
  
  # # Validations
  # validates_uniqueness_of :email, :message => "Conflicting email address."
 
  # Callbacks
  # after_create :populateLDAP
    
  # Accessors 
  def name
    self.fname.capitalize + " " + self.lname.capitalize
  end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end
  
 
protected
 
  #populate contact fields from LDAP
  def populateLDAP
    
    #quit if no email or netid to work with
    return if !self.netid
 
    ldap = Net::LDAP.new(host: 'directory.yale.edu', port: 389)
    b = 'ou=People,o=yale.edu'
    f = Net::LDAP::Filter.eq('uid', self.netid)
    a = %w(givenname sn mail knownAs class college)

    p = ldap.search(base: b, filter: f, attributes: a).first
  


    self.fname = ( p['knownAs'] ? p['knownAs'][0] : '' )
    if self.fname.blank?
      self.fname = ( p['givenname'] ? p['givenname'][0] : '' )
    end
    self.lname = ( p['sn'] ? p['sn'][0] : '' )
    self.email = ( p['mail'] ? p['mail'][0] : '' )
    self.year = ( p['class'] ? p['class'][0].to_i : 0 )
    self.college = ( p['college'] ? p['college'][0] : '' )
    self.save!
  end
end