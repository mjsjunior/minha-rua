class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	         :recoverable, :rememberable, :trackable, :validatable
	devise :omniauthable, :omniauth_providers => [:facebook]

  	def self.from_omniauth(auth)
	  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
	  	logger.debug "## USUARIO CADASTRO FACEBOOK ##"
	  	logger.debug auth.info.email
	  	logger.debug auth.info.name 
	  	logger.debug auth
	  	logger.debug Devise.friendly_token[0,20]

	    user.email = auth.info.email
	    user.encrypted_password = Devise.friendly_token[0,20]
	    user.first_name = auth.info.name   # assuming the user model has a name
	  end
	end

	def self.new_with_session(params, session)
	    super.tap do |user|
	      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
	        user.email = data["email"] if user.email.blank?
	      end
	    end
	end


	def password_required?
		super && provider.blank?
	end

end
