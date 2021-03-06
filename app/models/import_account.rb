require 'csv'


class ImportAccount
  def initialize(file)
    @file = file if file.present?
  end

  def import_gdrive(gdrive_file, assigned, campaign)
    if gdrive_file.blank?
      error = 'Select a .csv file or GDrive import' 
      return [error]
    end
    @assigned = assigned
    @campaign = campaign.id if campaign.present?

    # Get the file from gdrive_import helper script
    # We're using the gdrive command line utility from https://github.com/prasmussen/gdrive
    gdrive = File.expand_path("../../helpers/gdrive_import", __FILE__) # This is the path to the helper bash script
    gdrive_path = File.expand_path("../../helpers/dl", __FILE__) # This is the path where .csv files are downloaded
    gdrive_file_export = gdrive_path + "/*.csv" # This is the search path for the .csv files
    result = system(gdrive, 'dl', gdrive_file, gdrive_path) # This is the command to download the gdrive file

    # If gdrive exit was 0, continue to load the file
    if result
      @file = File.new(Dir[gdrive_file_export][0], "r") # Get only one file from gdrive_file_export folder (there should be only one! Fails if there are two or more..) TODO: Fail safe solution!
    else
      # Error handling for no file on gdrive etc.
      error = 'No file found on GDrive'
      return [error]
    end
    import
  end

  def import_file(assigned, campaign)
    if @file.blank?
      error = 'Select a .csv file or GDrive import' 
      return [error]
    end
    @assigned = assigned
    @campaign = campaign.id if campaign.present?
    import
  end

  # Sample Format for WorldCard Mobile (https://itunes.apple.com/en/app/worldcard-mobile-business/id333211045?mt=8) 
  # Export as CSV File Outlook format
def import
    total = 0
    c = 0
    error = ''
    
    # Error handling for wrong filetype
    if File.extname(@file.path) != '.csv' 
      error = 'Wrong filetype'
      return [error]
    end
    CSV.foreach(@file.path, :converters => :all, :return_headers => false, :headers => :first_row) do |row|
      first_name = row['First Name']
      last_name = row['Last Name']
      company = row['Company']
      title = row['Job Title']
      street = row['Business Street']
      city = row['Business City']
      state = row['Business State']
      zipcode = row['Business Postal Code']
      country = row['Business Country/Region']
      phone = row['Business Phone']
      mobile_phone = row['Mobile Phone']
      email = row['E-mail Address']
      alt_email = row['E-mail 2 Address']
      blog = row['Web Page']
      notes = row['Notes']
      *leftover = *row.to_hash.values
      
      # leftover array contains all remaining columns of the document, if you need additional values inserted, just address them like shown below 
      value1, value2, _ = *leftover

      # CCRM uses Alpha2 codes for countries, try to match here:
      # Using https://github.com/hexorx/countries
      countryCode = ISO3166::Country.find_country_by_name(country)
      countryCode = countryCode.alpha2 if countryCode.present?
      countryCode = country if countryCode.blank?

      # Check for duplicates based on first_name, last_name and email
      total += 1
      if Account.where(first_name: first_name, last_name: last_name, email: email).present?
        c += 1
	      next # Skip item if duplicate
      end

      account = Account.new(:title => title, :first_name => first_name, :last_name => last_name,
                      :email => email, :blog => blog, :alt_email => alt_email, :company => company, :phone => phone, :mobile => mobile_phone)

      # Add Account
      account.first_name = "FILL ME" if account.first_name.blank?
      account.last_name = "FILL ME" if account.last_name.blank?
      account.access = "Public"
      account.status = "new"
      account.assignee = @assigned if @assigned.present?
      account.campaign_id = @campaign if @campaign.present?
      account.save!

      # Add Business address to Account
      address = Address.new(:street1 => street, :city => city, :zipcode => zipcode, :country => countryCode, :addressable_id => account.id)
      address.addressable_type = 'Account'
      address.address_type = 'Business'
      address.save!

      # Add Comments to Account
      if notes
        notes = Comment.new(:comment => notes, :user_id => account.assigned_to, :commentable_id => account.id)
        notes.commentable_type = 'Account'
        notes.save!
      end
      
    end
    FileUtils.rm(@file.path)
    [error, total, c]
  end
end
