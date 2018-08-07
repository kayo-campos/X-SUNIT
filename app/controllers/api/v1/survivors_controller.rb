require_relative 'auxiliary_functions'

module Api
    module V1
        class SurvivorsController < ApplicationController

            ## Gets all survivors and calculates abducted and non-abducted percentages
            def index
                survivors = Survivor.order('name ASC')
                status = 'SUCCESS'
                data = {
                    survivors: survivors
                }
                statusCode = 200
                render_response(status, data, statusCode)
            end

            ## Get only the survivor wich id was passed via url param
            def show
                survivor = Survivor.find(params[:id])
                status = 'SUCCESS'
                data = {
                    survivor: survivor
                }
                statusCode = 200
                render_response(status, data, statusCode)
            end

            ## Creates a new survivor
            def create
                survivor = Survivor.new(survivor_params)
                if survivor.save and survivor.create_location(latitude: params[:latitude], longitude: params[:longitude])
                    status = 'SUCCESS'
                    data = {
                        survivor: survivor,
                        survivorLocation: survivor.location
                    }
                    statusCode = 200
                else
                    status = 'ERROR'
                    data = {
                        message: "couldn't create survivor"
                    }
                    statusCode = 400
                end
                render_response(status, data, statusCode)
            end

            ## Deletes a survivor
            def destroy
                survivor = Survivor.find(params[:id])
                AbductionReport.where("witness_id == ?", survivor.id).each { |report| report.destroy }
                if survivor.destroy
                    status = 'SUCCESS'
                    data = {
                        message: 'survivor deleted'
                    }
                    statusCode = 200
                else
                    status = 'ERROR'
                    data = {
                        message: "couldn't delete survivor"
                    }
                    statusCode = 400
                end
                render_response(status, data, statusCode)
            end

            ## Updates survivor information, but doesn't change his location (that's locations_controller business)
            def update
                survivor = Survivor.find(params[:id])
                if survivor.update(survivor_params)
                    status = 'SUCCESS'
                    data = {
                        survivor: survivor
                    }
                    statusCode = 200
                else
                    status = 'ERROR',
                    data = {
                        message: "couldn't update survivor information"
                    }
                    statusCode = 400
                end
                render_response(status, data, statusCode)
            end

            ## Not involved in Survivors CRUD, this function is called when hitting '/api/v1/general-information'
            def general_information
                abductedCount = Survivor.abducted.size
                nonAbductedCount = Survivor.non_abducted.size
                survivorsCount = abductedCount + nonAbductedCount
                if survivorsCount == 0
                    abductedPercentage = 0
                    nonAbductedPercentage = 0
                else
                    abductedPercentage = get_percentage(survivorsCount, abductedCount)
                    nonAbductedPercentage = 100 - abductedPercentage
                end
                status = 'SUCCES'
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
                statusCode = 200

                render_response(status, data, statusCode)
            end

            ## Some validations to http methods
            private
            def survivor_params
                params.permit(:name, :age, :gender)
            end
        end
    end
end