require 'spec_helper'

describe PostsController do
  login_user
  let(:new_post) { FactoryGirl.create :post, user_id: subject.current_user.id }

  before(:each) do
    Post.stub(:find).and_return(new_post)
  end

  describe "GET 'index'" do
    it "returns http sucess" do
      get 'index'
      response.should redirect_to root_path
    end
  end

  describe "GET 'show'" do
    it "gets posts for id" do
      get 'show', id: "1"
      response.should be_success
    end

    it "gets posts for id as JSON" do
      get 'show', id: "1", format: :json
      response.should be_success
    end
  end

  describe "GET 'new'" do
    context "when signed in" do

      it "returns http success" do
        get 'new'
        response.should be_success
      end

      it "gets posts for id as JSON" do
        get 'new'
        response.should be_success
      end
    end
    context "when not signed in" do
      it "redirects to signin when requesting html" do
        controller.stub(:current_user).and_return(nil)
        get 'new'
        response.should redirect_to new_user_session_path
      end

      it "redirects to signin when requesting JSON" do
        controller.stub(:current_user).and_return(nil)
        get 'new'
        response.should redirect_to new_user_session_path
      end
    end
  end

  describe "GET 'edit'" do
    context "when signed in" do
      login_user

      it "creates a new post" do
        get 'edit', id: new_post.id
        response.should be_success
      end
    end
    context "when not signed in" do
      it "redirects to signin when requesting html" do
        controller.stub(:current_user).and_return(nil)
        get 'edit', id: new_post.id
        response.should redirect_to new_user_session_path
      end
    end
  end

  describe "POST 'create'" do
    context "when signed in" do
      it "sends http success" do
        post 'create', post: new_post.attributes
        flash[:notice].should match('Post was successfully created.')
        response.should redirect_to post_path(assigns[:post])
      end

      context "on successful save" do
        it "makes the user upvote the post" do
          Post.stub(:new).and_return(new_post)
          subject.current_user.should_receive(:up_vote!).with(new_post)
          post 'create', post: new_post.attributes
        end

        it "renders json for post" do
          post 'create', post: new_post.attributes, format: :json
          json = JSON.parse(response.body)
          json["text"].length.should > 0
          response.status.should == 201
        end
      end

      context "on unsuccessful save" do
        it "renders the new template" do
          Post.any_instance.stub(:save).and_return(false)
          post 'create', post: new_post.attributes
          response.should render_template("new")
        end

        it "renders json with post.errors" do
          post 'create', post: { title: "" }, format: :json
          response.body.should match("too short")
          response.status.should == 422
        end
      end
    end

    context "when not signed in" do
      it "redirects to singin_path" do
        controller.stub(:current_user).and_return(nil)
        post 'create', post: new_post.attributes
        response.should redirect_to new_user_session_path
      end
    end
  end

  describe "PUT 'update'" do
    context "when signed in" do
      it "sends http success" do
        put 'update', id: new_post.id
        flash[:notice].should match('Post was successfully updated.')
        response.should redirect_to post_path(assigns[:post])
      end

      context "on successful update" do
        it "renders json for post" do
          put 'update', id: new_post.id, format: :json
          response.body.should == " "
          response.should be_success
        end
      end

      context "on unsuccessful save" do
        it "renders the edit template" do
          Post.any_instance.stub(:save).and_return(false)
          put 'update', id: new_post.id
          response.should render_template("edit")
        end

        it "renders json with post.errors" do
          put 'update', id: new_post.id, post: { link: "none" }, format: :json
          response.body.should match("is invalid")
          response.status.should == 422
        end
      end
    end

    context "when not signed in" do
      it "redirects to singin_path" do
        controller.stub(:current_user).and_return(nil)
        put 'update', id: new_post.id
        response.should redirect_to new_user_session_path
      end
    end
  end

  describe "DELETE 'destroy'" do
    it "should destroy model and redirect to index action" do
      delete :destroy, id: new_post.id
      response.should redirect_to(posts_url)
      Post.exists?(new_post.id).should be_false
    end

    it "should redirect to index action when trying to delete non-existant post" do
      delete :destroy, id: "9999"
      response.should redirect_to(posts_url)
      Post.exists?(new_post.id).should be_false
    end
  end

  #TODO FIX This is broken. No template to render
  #describe "#vote_up" do
  #  it "sends vote up message to User" do
  #    get 'vote_up', id: "1", format: :json
  #    subject.current_user.should_receive(:vote_down).once
  #  end
  #end
  #
  ##TODO FIX This is broken. No template to render
  #describe "#vote_down" do
  #  it "sends vote down message to User" do
  #    get 'vote_down', id: "1", format: :json
  #    subject.current_user.should_receive(:vote_up).once
  #  end
  #  it "does not vote up if the user has already voted" 
  #end
end
