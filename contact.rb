require 'csv'
require 'pry'

CONTACT_FILE = 'contacts.csv'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  attr_accessor :name, :email, :id, :phones
  @@allcontacts = []
  # Creates a new contact object
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
  def initialize(name, email, id, phones={})
    @name = name
    @email = email
    @id = id
    @phones = phones
  end

  # Provides functionality for managing contacts in the csv file.
  class << self

    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    def all
      @@allcontacts = []
      CSV.read(CONTACT_FILE).each_with_index {|contact, index|
        @@allcontacts.push(self.new(contact[0], contact[1], index, contact[2]))}
      @@allcontacts
    end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email
    def create(name, email, phones={})
      contact = nil
      if (self.all.detect {|contact| contact.email == email})
        raise 'Email already exists'
      end
      CSV.open(CONTACT_FILE, 'ab') do |csv_obj|
        csv_obj << [name, email, phones]
        # binding.pry
        contact = self.new(name, email, `wc -l #{CONTACT_FILE}`.to_i, phones)
      end
      @@allcontacts.push(contact)
      contact
    end
    
    # Find the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(id)

       self.all.detect {|contact| contact.id == id}
    end
    
    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    def search(term)
      term = term.downcase
      # TODO: Select the Contact instances from the 'contacts.csv' file whose name or email attributes contain the search term.
      self.all.select {|contact| 
        contact.name.downcase.include?(term) || contact.email.downcase.include?(term)
      }
    end

  end

end
