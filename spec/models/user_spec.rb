require "rails_helper"

describe User do
  it { should have_one(:location).dependent(:destroy) }
  it { should have_many(:donations).through(:location) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password).on(:create) }

  describe "#current_donation" do
    context "when the donor is registered with a Zone scheduled for pickups" do
      it "returns their donation" do
        location = create(:location, :supported)
        donor = location.user
        scheduled_pickup = create(:scheduled_pickup, zone: location.zone)
        donation = create(
          :donation,
          donor: donor,
          scheduled_pickup: scheduled_pickup,
        )

        current_donation = donor.current_donation

        expect(current_donation).to eq(donation)
      end
    end
  end
end
