class UserMailer < ActionMailer::Base
  default from: "job.board@test.com"
  
  def welcome_email(user)
    @user = user
    @url = "http://localhost:3000/login/validate/#{@user.id}?token=#{@user.validation_token}"
    mail(to: @user.email, subject: "Welcome to the Job Board!")
  end
end
