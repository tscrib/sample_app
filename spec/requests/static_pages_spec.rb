# This is the testing section.
# Everything in double quotes is a human-only description.
# describes are each test.

require 'spec_helper'

#
# Test for all static pages
#
describe "Static pages" do 

  subject{ page }

  # Test for the home page
  describe "Home page" do
    before{ visit root_path }

    it { should have_selector('h1', text: 'Sample App') }
    it { should have_selector('title', text: full_title('') ) }
    it { should_not have_selector('title', text: "| Home") }

  end

  # Test for the help page
  describe "Help page" do
    before{ visit help_path }
    
    it { should have_selector('h1', text: 'Help') }
    it { should have_selector('title', text: full_title('Help')) }

  end

  # Test for the about page
  describe "About page" do
    before{ visit about_path }
    
    it { should have_selector('h1', text: 'About Us') }
    it { should have_selector('title', text: full_title('About Us')) }

  end

  # Test for the contact page
  describe "Contact page" do
    before{ visit contact_path }
    
    it { should have_selector('h1', text: 'Contact') }
    it { should have_selector('title', text: full_title('Contact'))}

  end

end
