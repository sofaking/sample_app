require 'spec_helper'

describe "MicropostPages" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do
      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before { fill_in 'micropost_content', with: "Lorem ipsum" }

      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end

      describe "counter of microposts should get changed and correctly pluralized" do
        let(:another_user) { FactoryGirl.create(:user) }

        before do
          sign_in another_user
          visit root_path
          fill_in 'micropost_content', with: "Lorem ipsum" 
          click_button "Post" 
        end

        it { should have_content('1 micropost') }

        describe 'after adding one more post' do
          before do
            fill_in 'micropost_content', with: "Lorem lorem lorem" 
            click_button "Post" 
          end

          it { should have_content('2 microposts') }
        end

      end
    end
  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end
end
