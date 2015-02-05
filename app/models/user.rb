class User < ActiveRecord::Base
    belongs_to :referrer, :class_name => "User", :foreign_key => "referrer_id"
    has_many :referrals, :class_name => "User", :foreign_key => "referrer_id"
    
    #attr_accessible :email

    validates :email, :uniqueness => true, :format => { :with => /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/i, :message => "Invalid email format." }
    validates :referral_code, :uniqueness => true

    before_create :create_referral_code
    after_create :send_welcome_email

    REFERRAL_STEPS = [
        {
            'count' => 5,
            "html" => "One<br>Sock",
            "class" => "two",
            "image" =>  ActionController::Base.helpers.asset_path("refer/inferno.jpg")
        },
        {
            'count' => 10,
            "html" => "Spyderco Endura<br>Knife",
            "class" => "three",
            "image" => ActionController::Base.helpers.asset_path("refer/endura.jpg")
        },
        {
            'count' => 25,
            "html" => "Taser",
            "class" => "four",
            "image" => ActionController::Base.helpers.asset_path("refer/taser.jpg")
        },
        {
            'count' => 50,
            "html" => "Glock 19 Gen 4<br>Pistol",
            "class" => "five",
            "image" => ActionController::Base.helpers.asset_path("refer/glock.jpg")
        }
    ]

    private

    def create_referral_code
        referral_code = SecureRandom.hex(5)
        @collision = User.find_by_referral_code(referral_code)

        while !@collision.nil?
            referral_code = SecureRandom.hex(5)
            @collision = User.find_by_referral_code(referral_code)
        end

        self.referral_code = referral_code
    end

    def send_welcome_email
        UserMailer.delay.signup_email(self)
    end
end
