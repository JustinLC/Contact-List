#!/usr/bin/ruby

require_relative 'contact'
require 'pry'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.

  def initialize

  end

  class << self
    def main_menu
      puts "Here is a list of available commands:"
      puts "\tnew - Create a new contact"
      puts "\tlist - List all contacts"
      puts "\tshow - Show contacts"
      puts "\tsearch - Search contacts"
    end

    def make
      puts "Enter name: "
      # binding.pry
      name = STDIN.gets.chomp
      puts "Enter email: "
      email = STDIN.gets.chomp
      phones = {}
      puts "Enter phone label (hit q to exit)"
      plabel = STDIN.gets.chomp
      while (plabel != 'q')
        puts "Enter phone number"
        pnum = STDIN.gets.chomp.to_i
        phones[plabel.to_sym] = pnum
        puts "Enter phone label (hit q to exit)"
        plabel = STDIN.gets.chomp
      end
      begin
        contact = Contact.create(name, email, phones)
        # binding.pry
        puts "Contact created: \t#{contact.id}. #{contact.name} (#{contact.email}) #{contact.phones}"
      rescue Exception => e
        puts e.message
      end
    end

    def show(id)
      contact = Contact.find(id.to_i)
      # binding.pry
      if (contact)
        puts "Contact found: \t#{contact.id}. #{contact.name} (#{contact.email}) #{contact.phones}"
      else
        puts "Contact not found"
      end
    end

    def list
      list = Contact.all
      list.each_with_index {|contact, index|
        puts "#{contact.id}. #{contact.name} (#{contact.email}) #{contact.phones}"
        if ((index+1) % 5 == 0 && list.size > index + 1)
          puts "Hit enter to continue"
          STDIN.gets.chomp
        end
      }
    end

    def search(term)
      list = Contact.search(term)
      if (list.size > 0)
        list.each {|contact| 
          puts "#{contact.id}. #{contact.name} (#{contact.email}) #{contact.phones}"
        }
      else 
        puts "Nothing found"
      end
    end

  end

end

case ARGV[0]
when nil
  ContactList.main_menu
when "list" 
  ContactList.list
when "new"
  ContactList.make
when "show"
  ContactList.show(ARGV[1])
when "search"
  ContactList.search(ARGV[1])
end