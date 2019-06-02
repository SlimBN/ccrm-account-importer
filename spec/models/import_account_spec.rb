require 'spec_helper'

describe ImportAccount do
  let(:file) { File.open(File.join(File.dirname(File.realpath(__FILE__)), "../factories/sampleAccounts.csv").to_s) }
  subject { ImportAccount.new(file) }

  it "creates all the accounts in the file" do
    expect { subject.import }.to change(Account.count).by(file.readlines)
  end
end
