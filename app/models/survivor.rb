class Survivor < ApplicationRecord
    has_many :abduction_reports

    validates :name, presence: true
    validates :age, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :gender, presence: true, format: { with: /f|m|nb/, message: "wait, if you're not male, female or non-binary, then are you an alien?" }
    validates :latitude, presence: true, numericality: true
    validates :longitude, presence: true, numericality: true
    after_initialize :init

    def init
        self.abducted ||= false # make sure a survivor is still among us when inserted in database
    end
end
