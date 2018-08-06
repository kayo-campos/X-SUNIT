require_relative 'auxiliary_functions'

module Api
    module V1
        class LocationsController < ApplicationController
            def show
                survivor = Survivor.find(params[:survivor_id])
                status = 'SUCCESS'
                data = {
                    location: survivor.location
                }
                statusCode = 200
                render_response(status, data, statusCode)
            end

            def update
                survivor =  Survivor.find(params[:survivor_id])
                if survivor.location.update(location_params)
                    status = 'SUCCES'
                    data = {
                        location: survivor.location
                    }
                    statusCode = 200
                else
                    status = 'ERROR',
                    data = {
                        message: "Couldn't update survivor location"
                    }
                    statusCode = 400
                end
                render_response(status, data, statusCode)
            end

            ## Side-function so code is clean
            private
            def location_params
                params.permit(:latitude, :longitude)
            end
        end
    end
end