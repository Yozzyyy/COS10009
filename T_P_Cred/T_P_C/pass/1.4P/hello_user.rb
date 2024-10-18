require 'date'

INCHES = 39.3701  # This is a global constant

# Insert the missing code here into the statements below:
# gets()
# gets.chomp()
# Date.today.year
# year_born.to_i()
# gets.to_f()

def main()
	puts('What is your name?')
	name = gets.chomp()
	puts('Your name is ' + name)
	puts ('!')
	puts('What is your family name?')
	family_name = gets.chomp.to_s()
	puts('Your family name is: ' + family_name + '!')
	puts('What year were you born?')
	year_born = gets.chomp.to_i()
	# Calculate the users age
	age = Date.today.year - year_born
	puts('So you are ' + age.to_s + ' years old')
	puts('Enter your height in metres (i.e as a float): ')
	value =  gets.chomp.to_f
	value = value * INCHES
	puts('Your height in inches is: ') 
	puts(value.to_s)
	puts('Finished')
end

main()

