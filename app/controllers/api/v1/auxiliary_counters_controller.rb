require_relative 'auxiliary_functions'

module Api
    module V1
        class AuxiliaryCountersController < ApplicationController
            def index
                nonAbductedCount = AuxiliaryCounter.find(1).count
                abductedCount = AuxiliaryCounter.find(2).count
                survivorsCount = abductedCount + nonAbductedCount
                if survivorsCount == 0
                    abductedPercentage = 0
                    nonAbductedPercentage = 0
                    status = 'ERROR'
                    statusCode = 400
                else
                    abductedPercentage = get_percentage(survivorsCount, abductedCount)
                    nonAbductedPercentage = 100 - abductedPercentage
                    status = 'SUCCES'
                    statusCode = 200
                end
                data = {
                    survivors_count: survivorsCount,
                    abducted: {
                        count: abductedCount,
                        percentage: abductedPercentage
                    },
                    non_abducted: {
                        count: nonAbductedCount,
                        percentage: nonAbductedPercentage
                    }
                }
                render_response(status, data, statusCode)
            end

            def get_percentage(maximumValue, acctualValue)
                percentage = (100 * acctualValue) / maximumValue
                return percentage
            end
        end
    end
end