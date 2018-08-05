module Api
    module V1
        class SurvivorsController < ApplicationController
            
            ## Gets all survivors and calculates abducted and non-abducted percentages
            def index
                survivors = Survivor.order('name ASC')
                abductedPercentage = get_abducted_percentage(survivors)
                ## If there are no survivors, it just makes sense 0% of them is abducted and 0% of then is non-abducted
                if survivors.count == 0
                    nonAbductedPercentage = 0
                else
                    nonAbductedPercentage = 100 - abductedPercentage
                end
                status = 'SUCCESS'
                data = {
                    survivors: survivors,
                    abductedPercentage: abductedPercentage,
                    nonAbductedPercentage: nonAbductedPercentage
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
                abductionReports = AbductionReport.where("witness_id == ?", survivor.id).each { |report| report.destroy }
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
                else
                    status = 'ERROR',
                    data = {
                        message: "couldn't update survivor information"
                    }
                end
                render_response(status, data, statusCode)
            end


            ## Some validations to http methods
            private
            def survivor_params
                params.permit(:name, :age, :gender)
            end

            ## Side-function so it gets easier to change some logic in the abducted percentage calculation
            def get_abducted_percentage(survivorsArray)
                size = survivorsArray.count
                if size == 0
                    return 0
                else
                    abductedCount = survivorsArray.count{ |survivor| survivor[:abducted] }
                    abductedPercentage = (100 * abductedCount) / size
                    return abductedPercentage
                end
            end

            ## Side-function to handle HTTP responses, since they follow a pattern of STATUS_CODE, STATUS_MESSAGE and DATA
            def render_response(status, data, statusCode)
                render json: {
                    status: status,
                    data: data
                }, status: statusCode
            end

        end
    end
end