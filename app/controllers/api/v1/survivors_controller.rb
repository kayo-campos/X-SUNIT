module Api
    module V1
        class SurvivorsController < ApplicationController
            def index
                survivors = Survivor.order('name ASC')
                render json: {
                    status: 'SUCCESS',
                    data: survivors
                }, status: :ok
            end

            def show
                survivor = Survivor.find(params[:id])
                render json: {
                    status: 'SUCCESS',
                    data: survivor
                }, status: :ok
            end

            def create
                survivor = Survivor.new(survivor_params)
                if survivor.save
                    render json: {
                        status: 'SUCCESS',
                        data: survivor
                    }, status: :ok
                else
                    render json: {
                        status: 'ERROR',
                        data: survivor.errors
                    }, status: :unprocessable_entry
                end
            end

            private
            def survivor_params
                params.permit(:name, :age, :gender, :latitude, :longitude)
            end
        end
    end
end