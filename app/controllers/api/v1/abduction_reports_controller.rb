module Api
    module V1
        class AbductionReportsController < ApplicationController
            def create
                ## Having a reference to survivor and witness objects, we make sure they exist
                survivor = Survivor.find(params[:survivor_id])
                witness = Survivor.find(params[:witness_id])
                ## A survivor shouldn't be able to report his own abduction since he's probably in the UFO
                if survivor.id == witness.id
                    status = 'ERROR'
                    data = {
                        message: "a survivor can't report his/her own abduction"
                    }
                    statusCode = 400
                ## If a survivor already reported antoher survivor abduction, then the array below should be empty
                elsif AbductionReport.find_by(witness_id: params[:witness_id], survivor_id: params[:survivor_id]) != nil
                    status = 'ERROR'
                    data = {
                        message: "witness already reported this abduction"
                    }
                    statusCode = 400
                ## If an abducted survivor is reporting another survivor abduction, then we have a problem
                elsif witness.abducted == true
                    status = 'ERROR'
                    data = {
                        message: "an abducted survivor can't report another survivor abduction"
                    }
                    statusCode = 400
                else
                    abductionReport = AbductionReport.new(abduction_report_params)
                    abductionReport.save
                    witnessesReportingAbduction = find_witnesses(params[:survivor_id], params[:witness_id])
                    if witnessesReportingAbduction >= 3 and survivor[:abducted] == false
                        survivor.update(abducted: true)
                    end
                    status = 'SUCCES'
                    data = {
                        message: "abduction reported",
                        abduction_report: abductionReport
                    }
                    statusCode = 200
                end

                render_response(status, data, statusCode)
            end

            private
            def abduction_report_params
                params.permit(:survivor_id, :witness_id)
            end

            ## Side-function to count how many witnesses reported survivor abduction
            def find_witnesses(survivor_id, witness_id)
                survivorAbductionReports = AbductionReport.where('survivor_id == ?', survivor_id)
                witnessesReportingAbduction = survivorAbductionReports.map { |report| report[:witness_id] }.uniq.count
                return witnessesReportingAbduction
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
