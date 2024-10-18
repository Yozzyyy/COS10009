require_relative "./input_functions"



def label()
	# ask user to enter their title
	title = read_string('Please enter your title: (Mr, Mrs, Ms, Miss, Dr)')
	# ask user to enter their first name
	fname = read_string('Please enter your first name:')
	# ask user to enter their last name
	lname = read_string('Please enter your last name:')
	# ask user to enter their house or unit number
	hnum = read_string('Please enter the house or unit number:')
	# ask user to enter their street name
	sname = read_string('Please enter the street name:')
	# ask user to enter their suburb
	suburb = read_string('Please enter the suburb:')
	# ask user to enter their postcode
	postcode = read_integer_in_range("Please enter a postcode (0000 - 9999)", 0000, 9999).to_s

	return title + " " + fname + " " + lname + "\n" + hnum + " " + sname +
	"\n" + suburb + " " + postcode
end

# Return the contents of the letter / message to be send
def letter_content()
	# Prompt user to enter their subject line
	subject_line = read_string('Please enter your message subject line:')
	# Prompt user to enter their message content
	content = read_string('Please enter your message content:')


	return ('RE: ') + subject_line + "\n\n" + content #printing the subject_line and content
end

# Prints the label and message
def printletter(label_text, message)
	puts label_text
	puts message
end

def main()
	# Arrange the user inputs
	label_text = label() #taking from the first function
	message = letter_content() #taking from the second function

	# Print out the label(title,etc) and the message
	printletter(label_text, message)
end

# Call the main function
main()
