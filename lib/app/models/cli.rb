



puts "Welcome! Log in? Sign up?"
welcomechoice = gets.chomp
case welcomechoice
when "login"
  puts "What is your Username? "
  username = gets.chomp
  if
when "sign up"
    puts "What would you like to be called?"
    newuser_name = gets.chomp
    puts "How old are you? Human years please."
    newuser_age = gets.chomp
    puts "What is your location?"
    newuser_location = gets.chomp
    User.create(newuser_name, newuser_age, newuser)
end