class Item < ApplicationRecord
    belongs_to :shortner

    before_validation :smart_add_url_protocol
    before_create :smart_add_url_protocol
    after_create :take_screencap


    def take_screencap
        Dir.chdir(Rails.root.join('public', 'images'))
        system "phantomjs #{Rails.root.join('lib', 'screencap.js')} #{self.href} item_#{self.id}.png &"
    end

    protected

    def smart_add_url_protocol
        unless self.href[/\Ahttp:\/\//] || self.href[/\Ahttps:\/\//]
             self.href = "https://#{self.href}"
        end
    end

end
