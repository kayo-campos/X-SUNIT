module Api
    module V1
        class LocationsController < ApplicationController
            def index
                survivor = Survivor.find(params[:survivor_id])
                render json: {
                    status: 'SUCCESS',
                    data: survivor.location
                }, status: :ok
            end

            def update
                survivor =  Survivor.find(params[:survivor_id])
                if survivor.location.update(location_params)
                    render json: {
                        status: 'SUCCESS',
                        data: survivor.location
                    }, status: :ok
                else
                    render json: {
                        status: 'ERROR',
                        message: "Couldn't update survivor location"
                    }, status: :unprocessable_entry
                end
            end

            private
            def location_params
                params.permit(:latitude, :longitude)
            end
        end
    end
end