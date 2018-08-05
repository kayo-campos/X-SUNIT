class AbductionReport < ApplicationRecord
    belongs_to :survivor

    validates :survivor_id, presence: true
    validates :witness_id, presence: true
end
