class UserMailer < ActionMailer::Base
    default from: "socks company <welcome@acme.com>"

    def signup_email(user)
        @user = user
        @twitter_message = "New socks. Excited for SOCKS to launch."

        mail(:to => user.email, :subject => "Thanks for signing up!")
    end
end
