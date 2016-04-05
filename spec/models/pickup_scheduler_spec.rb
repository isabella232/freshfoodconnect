require "rails_helper"

describe PickupScheduler do
  context "when there are no pickups scheduled for the current week" do
    it "creates a ScheduledPickup" do
      beginning_of_week = Time.current.sunday.beginning_of_day

      Timecop.freeze(beginning_of_week) do
        delivery_zone = create(
          :delivery_zone,
          start_hour: 0,
          end_hour: 1,
          weekday: beginning_of_week.wday,
        )
        create(
          :scheduled_pickup,
          delivery_zone: delivery_zone,
          start_at: beginning_of_week - 1.day,
          end_at: beginning_of_week - 1.day,
        )
        scheduler = PickupScheduler.new(delivery_zone)

        scheduler.schedule!
        scheduled_pickup = ScheduledPickup.last

        expect(ScheduledPickup.count).to eq(2)
        expect(scheduled_pickup.start_at.hour).to eq(0)
        expect(scheduled_pickup.end_at.hour).to eq(1)
        expect(scheduled_pickup.start_at.wday).to eq(0)
      end
    end
  end

  context "when there is already a Pickup scheduled for the week" do
    it "doesn't create a ScheduledPickup" do
      beginning_of_week = Time.current.sunday.beginning_of_day

      Timecop.freeze(beginning_of_week) do
        delivery_zone = create(
          :delivery_zone,
          weekday: beginning_of_week.wday,
        )
        create(
          :scheduled_pickup,
          delivery_zone: delivery_zone,
          start_at: beginning_of_week + 1.hour,
          end_at: beginning_of_week + 2.hours,
        )
        scheduler = PickupScheduler.new(delivery_zone)

        scheduler.schedule!

        expect(ScheduledPickup.count).to eq(1)
      end
    end
  end
end