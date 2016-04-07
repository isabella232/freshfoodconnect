require "rails_helper"

describe "donations/current" do
  context "when there is a donation" do
    it "displays profile information" do
      tomorrow_at_noon = Date.new(2016, 4, 7).middle_of_day
      scheduled_pickup = build(
        :scheduled_pickup,
        start_at: tomorrow_at_noon,
        end_at: tomorrow_at_noon + 1.hour,
      )
      donation = build_stubbed(:donation, scheduled_pickup: scheduled_pickup)

      render("donations/current", donation: donation)

      expect(rendered).to have_text("04/07/2016")
      expect(rendered).to have_text(label_for_noon)
      expect(rendered).to have_text(label_for_1pm)
    end

    context "when there isn't a donation" do
      it "informs the User there won't be a donation" do
        render("donations/current", donation: nil)

        expect(rendered).to have_text(t("donations.current.none"))
      end
    end

    def label_for_1pm
      Hour.find(13).label
    end

    def label_for_noon
      Hour.find(12).label
    end
  end
end
