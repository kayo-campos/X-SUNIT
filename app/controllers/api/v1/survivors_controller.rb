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
                    update_auxiliary_count(1, :+)
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
                    if survivor.abducted
                        update_auxiliary_count(2, :-)
                    else
                        update_auxiliary_count(1, :-)
                    end
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


            ## Some validations to http methods
            private
            def survivor_params
                params.permit(:name, :age, :gender)
            end

            ## Side-function so it gets easier to change some logic in the auxiliary counters
            private
            def update_auxiliary_count(id, operation)
                survivorsAuxiliaryCounter = AuxiliaryCounter.find_by(id: id)
                if operation == :+
                    survivorsAuxiliaryCounter.update(count: survivorsAuxiliaryCounter.count + 1)
                elsif operation == :-
                    survivorsAuxiliaryCounter.update(count: survivorsAuxiliaryCounter.count - 1)
                end
            end
        end
    end
end