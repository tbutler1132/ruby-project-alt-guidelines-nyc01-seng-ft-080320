require_relative 'user.rb'
require_relative 'album.rb'
require_relative 'collection.rb'

# puts String.color_samples
ActiveRecord::Base.logger.level = 1 # or Logger::INFO

Catpix::print_image "lib/app/imgs/Screen Shot 2020-08-20 at 5.03.08 PM.png",
  :limit_x => 1.0,
  :limit_y => 0,
  :center_x => true,
  :center_y => true,
  :bg => "white",
  :bg_fill => false,
  :resolution => "high"
  def run
    prompt = TTY::Prompt.new 
    member = prompt.yes?("Are you already a member?")

    if member == true
        user_name = prompt.ask("Please input your name:".white.on_light_black.bold)
        if User.exist?(user_name)
            review = true
            while review != false
                Catpix::print_image "lib/app/imgs/Screen Shot 2020-08-20 at 8.58.00 AM.png",
  :limit_x => 1.0,
  :limit_y => 0,
  :center_x => true,
  :center_y => true,
  :bg => "white",
  :bg_fill => false,
  :resolution => "high"
                current_user = User.log_in(user_name)
                current_user.existing_member_prompt
                current_user.add_delete_prompt
                current_user.view_popularity 
                review = prompt.yes?("Would you like to review your options again?")
            end
        else
            puts "We don't recognize you. Please input the following info and you will either be signed in or a new account will be created:"
            current_user = User.sign_up_or_log_in
            current_user.new_user_prompt
            choice = prompt.yes?("Would you like to review your options again?")
                if choice == true
                    review = true
                    while review != false
                        current_user.existing_member_prompt
                        current_user.add_delete_prompt
                        current_user.view_popularity 
                        review = prompt.yes?("Would you like to review your options again?")
                    end
                end 
        end
               
system "clear"

    else member == false
        current_user = User.sign_up_or_log_in  
        current_user.new_user_prompt
        choice = prompt.yes?("Would you like to review your options again?")
            if choice == true
                review = true
                while review != false
                    current_user.existing_member_prompt
                    current_user.add_delete_prompt
                    current_user.view_popularity 
                    review = prompt.yes?("Would you like to review your options again?")
                end
            end

    end
    

end
   
run 