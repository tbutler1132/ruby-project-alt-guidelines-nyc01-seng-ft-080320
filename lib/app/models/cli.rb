require_relative 'user.rb'
require_relative 'album.rb'
require_relative 'collection.rb'

# puts String.color_samples

def run
    prompt = TTY::Prompt.new 
    member = prompt.yes?("Are you already a member?")
    review = true
    while review != false
    if member == true
        user_name = prompt.ask("Please input your name:".white.on_light_black.bold)
        if User.exist?(user_name)
            current_user = User.log_in(user_name)
            current_user.existing_member_prompt
            current_user.add_delete_prompt 
        else
            puts "We don't recognize you. Please input the following info and you will either be signed in or a new account will be created:"
            current_user = User.sign_up_or_log_in
            current_user.new_user_prompt 
        end
# system "clear"
        # current_user.add_delete_prompt               
        choice = prompt.yes?("Would you like to view your current collection?")
system "clear"
        if choice == true
            Collection.display_albums(current_user)
        end
    else member == false
        current_user = User.sign_up_or_log_in  
        current_user.new_user_prompt
    end
    review = prompt.yes?("Would you like to start over")
    end 
    

end
   
run 