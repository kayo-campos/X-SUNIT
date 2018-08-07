class Survivor < ApplicationRecord
    has_many :abduction_reports, dependent: :destroy
    has_one :location, dependent: :destroy

    ## Some validation to make sure real world information is being represented as data
    validates :name, presence: true
    validates :age, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :gender, presence: true, format: { with: /f|m|nb/, message: "wait, if you're not male, female or non-binary, then are you an alien?" }
    
    scope :abducted, -> { where(abducted: true) }
    scope :non_abducted, -> { where(abducted: false) }

    after_initialize :init

    ## Side-function to make sure a survivor is still among us when inserted in database
    def init
        self.abducted ||= false
    end
end
