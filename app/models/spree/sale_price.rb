module Spree
  class SalePrice < ActiveRecord::Base
    # TODO validations
    belongs_to :price, :class_name => "Spree::Price"
    attr_accessible :price_id, :value, :start_at, :end_at, :enabled

    scope :active, lambda {
      where("enabled = 't' AND (start_at <= ? OR start_at IS NULL) AND (end_at >= ? OR end_at IS NULL)", Time.now, Time.now)
    }

    def price
      self.value
    end

    def enable
      update_attribute(:enabled, true)
    end

    def disable
      update_attribute(:enabled, false)
    end

    def start(end_time = nil)
      end_time = nil if end_time.present? && end_time <= Time.now # if end_time is not in the future then make it nil (no end)
      attr = { end_at: end_time, enabled: true }
      attr[:start_at] = Time.now if self.start_at.present? && self.start_at > Time.now # only set start_at if it's not set in the past
      update_attributes(attr)
    end

    def stop
      update_attributes({ end_at: Time.now, enabled: false })
    end
  end
end
