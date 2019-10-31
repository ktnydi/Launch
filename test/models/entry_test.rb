require 'test_helper'

class EntryTest < ActiveSupport::TestCase
  test "should get publics" do
    user = create(:user)
    entries = create_list(:entry, 10, user_token: user.uuid)
    assert Entry.publics.all? { |public| public.status == 1 }
  end
end
