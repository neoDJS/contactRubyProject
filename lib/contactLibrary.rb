require 'json'
require_relative  'contactClass'
require_relative  'stringClass'


Menu ={ 1 => {label: "Add a new contact",
			  bloc: define_method("add_contact"){ 
													c = Contact.new
													c.last_name = getName("last")
													c.first_name = getName("first")
													c.address = getAddress
													c.mail = getMail
													c.tel = getPhone
													Contact.save(c)
													return true
												}
			 },
        2 => {label: "Change a contact info",
			  bloc: define_method("chg_contact"){ 
													count = 0
													exit = false
													done = eval Menu[3][:bloc].to_s+"("")"
													if done
														puts ""
														puts "which contact you wanna update? (Enter his number)"
														id = getAnInteger(1, Contact.all.length) - 1
														c = Contact.all.detect{|c| c.match?(id) }
														
														while !finished?(count)
															puts "What do you want to change on this contact?"
															puts "\t1 - Name"
															puts "\t2 - Address"
															puts "\t3 - Email"
															puts "\t4 - Phone"
															puts "\t5 - Exit"
															puts "Choose the number of the property you wanna change :"
															prop = getAnInteger(1, 5)
															case prop
																when 1 
																		c.last_name = getName("last")
																		c.first_name = getName("first")
																		puts "Name changed"
																when 2 
																		c.address = getAddress
																		puts "Address changed"
																when 3 
																		c.mail = getMail
																		puts "Mail changed"
																when 4 
																		c.tel = getPhone
																		puts "Phone changed"
																when 5 
																		exit = true #c.tel = getPhone
																		puts "no more change"
																else 
																		puts "bad choice. property not on the list"
															end
															
															break if exit
															
															count += 1
														end
													end
													return done
												}
			 },
        3 => {label: "List all contact info",
			  bloc: define_method("list_contact"){ |val=4|
			  										done = false
													if !Contact.all.empty?
														puts "Here is the Contact list: \n\n" 
														Contact.all.each{|c| c.printed(val) }
														done = true
													else
														puts "There is no contact in the list. List is Empty"
													end
													return done
												 }
			 },
        4 => {label: "Delete a contact",
			  bloc: define_method("del_contact"){ 
													done = send(Menu[3][:bloc], "")
													if done
														val = ""
														cname = ""
														val  = getName("last")
														cname += "#{val.upcase}"
														val = getName("first")
														cname += " #{val.new_capitalize}"
														
														Contact.delete_by_name(cname)
													end
													return done
												}
			 },
        5 => {label: "Exit",
			  bloc: define_method("done"){ puts "Done !"
											 return true 
										 }
			 }
}

def finished?(round)
	finishing = false
	if round > 0
		puts "\nAre you done Changing the contact yet?(y/n)"
		finishing = gets.strip.chars[0].downcase == "y" ? true : false 
	end
	finishing
end

def terminated?(round)
	finishing = false
	if round > 0
		puts "\ndo you want to exit the program?(y/n)"
		finishing = gets.strip.chars[0].downcase == "y" ? true : false 
	end
	finishing
end

def getName(val)
	count = 0
	cname = ""
	m = /\A[a-zA-Z\s]+\z/
	while !cname.validate(m)
		puts "Please write your #{val} name#{count>0? " again" : ""} :" 
		cname = gets.strip
		count += 1
	end
	cname
end

def getAddress
	count = 0
	caddress = ""
	m = /\A\d+,[a-zA-Z,.#\s\d]+\z/
	while !caddress.validate(m)
		puts "Please write your physical address#{count>0? " again" : ""} :"
		caddress = gets.strip
		count += 1
	end
	caddress
end

def getMail
	count = 0
	cmail = ""
	m = /\A([a-zA-Z\d_$#]+)@([a-zA-Z]+).([a-zA-Z]+)\z/
	while !cmail.validate(m)
		puts "Please write your mail address#{count>0? " again" : ""} :"
		cmail = gets.strip
		count += 1
	end
	cmail
end

def getPhone
	count = 0
	cphone = ""
	m = /\A(\d+|\()\d+(\s|\)|-|\d)\d+(\s|\)|-|\d)\d+\z/
	while !cphone.validate(m)
		puts "Please write your phone number#{count>0? " again" : ""} :"
		cphone = gets.strip
		count += 1
	end
	cphone
end

def getAnInteger(from, to)
	count = 0
	cInt = ""
	m = /\A\d+\z/
	while !(cInt.validate(m) && (from..to).cover?(cInt.to_i))
		puts "Invalid number.\n Please choose again : " if count>0
		cInt = gets.strip
		count += 1
	end
	cInt.to_i
end

def running
	count = 0
	exit = false
	Contact.load
	
	while !terminated?(count)
		puts "\n\n\t\tWELCOME to my Contact App\n" if count < 1
		puts "\tHere is the menu: "
		Menu.each{|k, o| puts "\t\t#{k} - #{o[:label]}" }
		puts "\tWhat do you want to do?"
		puts "\tChoose the number of the menu option you want work with :\n"
		opt = getAnInteger(1, Menu.keys.last)#gets.strip.to_i
		
		puts "#{opt} - #{Menu[opt][:label]}"
		exit = (send Menu[opt][:bloc]) && (opt == 5)
		break if exit
		 
		count += 1
	end
	Contact.saveAll
end