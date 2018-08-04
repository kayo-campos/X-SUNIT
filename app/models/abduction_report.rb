class AbductionReport < ApplicationRecord
    validates :survivor_id, presence: true
    validates :witness_id, presence: true
end
