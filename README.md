# CcrmImportAccounts

This project rocks and uses MIT-LICENSE.

## Installation

Cos CRM Account Importer works with Cos CRM 0.14.0 onwards. You can add this to your Gemfile:

```ruby
gem 'ccrm_import_accounts', :git => 'https://github.com/SlimBN/Cos-CRM-Account-Importer.git', :branch => "master"
```

If you use the WorldCard Mobile app - use the master branch ````:branch => "master"```` otherwise you can use the not maintained ````generic_csv```` branch.

Run the ````bundle install```` command to install it.

Now featuring direct gdrive import!

This plugin has some hard coded values:
- account.access = "Public" // Access for all imported accounts will be public
- account.status = "new" // Status will be set to 'New'
- Check for duplicates based on first name, last name and email

## Screenshot
![image](https://cloud.githubusercontent.com/assets/18528524/15040285/19af8daa-12e6-11e6-9bec-d09eb858ef8e.png)

## TODO

- Remove hardcoded values
- Error handling

All these values or the order of the import document can be edited in this file: [import_account.rb](https://github.com/georgTW/Cos-CRM-Account-Importer/blob/master/app/models/import_account.rb)

