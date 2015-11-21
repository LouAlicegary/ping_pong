require "test_helper"

describe GroupMembership do
  let(:group_membership) { GroupMembership.new }

  it "must be valid" do
    value(group_membership).must_be :valid?
  end
end
