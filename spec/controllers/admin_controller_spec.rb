require 'spec_helper'

describe AdminController do
  login_user
  context "logged in as user" do

    describe "GET 'mail'" do
      it "requires that the user is admin" do
        expect { get 'mail' }.to raise_error(CanCan::AccessDenied)
        #TODO response.should redirect_to root_path
      end
    end

    describe "POST 'send_newsletter'" do
      it "requires that the user is admin" do
        expect { post 'send_newsletter' }.to raise_error(CanCan::AccessDenied)
      end
    end
  end

  context "logged in as admin" do
    before(:each) do
      [{ resource: :all, action: :mail }, { resource: :all, action: :send_newsletter }].each do |hash|
        controller.current_user.admin_auths.create hash
      end
    end

    describe "GET 'mail'" do
      it "returns HTTP success" do
        get :mail
        response.should be_success
      end
    end

    describe "POST 'send_newsletter'" do
      before(:each) do
        controller.stub(:user_signed_in?).and_return(true)
        mailer = mock_model("Mailer", newsletter: nil)
        UserMailer.stub(:delay).and_return(mailer)
        mailer.should_receive(:newsletter).once

      end

      #TODO refactor the implementation code for this. It's strange
      it "returns HTTP success if the user is signed in" do
        controller.stub(:user_signed_in?).and_return(true)
        
        post :send_newsletter, subject: "Test", text: "Texttest"
        response.should redirect_to admin_mail_path
        flash[:notice].should == "Mail sent"
      end
    end
  end
end

