require_relative  'stringClass'

class Contact
    @@all = []
    attr_accessor :address, :mail, :tel
    attr_writer :first_name, :last_name
    def initialize(contct = {})
      if contct.empty?
          @id = @@all.length
          puts "baaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaad"
      else
          @id = contct[:id]
          @first_name = contct[:fname]
          @last_name = contct[:lname]
          @address = contct[:address]
          @tel = contct[:phone]
          @mail = contct[:mail]
      end
      #@@all << self
    end
  
    def name
      "#{@last_name.upcase} #{@first_name.new_capitalize}"
    end
  
    def match?(id)
      @id == id
    end
  
    def self.all
      @@all
    end
  
    def self.delete_by_name(cname)
      @@all = @@all.delete_if{|c| c.name == cname}
      saveAll
    end
    
    def as_json
      {
          id: 		@id,
          fname: 	@first_name,
          lname: 	@last_name,
          address:	@address,
          phone:	@tel,
          mail:		@mail
      }
    end
    
    def self.load
        count = 0
      if File.exist?('contacts.json')
          File.foreach('contacts.json') { |line|
            #puts "#{count} - " + line
            #puts JSON.parse(line,:symbolize_names => true)
              @@all << Contact.new(JSON.parse(line, :symbolize_names => true))
              count += 1
          }
          puts "\nContacts loaded!\n"
      else
          puts "\nJson Contact file does not exist\n"
      end
      puts all
    end
    
    def self.load2
      if File.exist?('contacts.json')
          File.open('contacts.json') {|fc|
              content = fc.read
              contact_data = JSON.parse(content)
              if contact_data.is_a?Hash
                  @@all << Contact.new(contact_data)
              elsif contact_data.is_a?Array
                  contact_data.each{|c| @@all << Contact.new(c) }
              end
          }
          puts "Contacts loaded!"
      else
          puts "Json Contact file does not exist"
      end
    end
    
    def self.save(c)
        File.open('contacts.json', 'a+') { |fc|
            fc.puts c.to_json
        }
    end
    
    def self.saveAll
        File.open('contacts.json', 'w') { |fc|
            all.each{|c|
                fc.puts c.to_json
            }
        }
    end
    
    def to_json(*option)
        as_json.to_json(*option)
    end
  
    def printed(num = "")
      print "#{num != "" ? num : @id+1} - Full name: #{name}"
      puts ", live at #{@address}"  if num.is_a?Integer #num > 1
      puts "\tContacted by mail at: #{@mail}\n\t by phone at: #{@tel}" if num.is_a?Integer #num > 3
      puts "\n\t\t"+"".center(50,"-")
    end
  
  end
  