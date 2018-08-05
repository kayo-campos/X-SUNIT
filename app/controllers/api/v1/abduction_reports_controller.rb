module Api
    module V1
        class AbductionReportsController < ApplicationController
            def create

                ## A survivor shouldn't be able to report his own abduction since he's probably in the UFO
                if params[:survivor_id] == params[:witness_id]
                    render json: {
                        status: 'ERROR',
                        message: "A survivor can't report his/her/hxr own abduction"
                    }
                ## We all know you get nervous when a friend of yours gets abducted by an alien, but if we still care about design patterns in an alien apocalypse, why shouldn't we care about saving some database storage (and other problems, of course)?
                elsif AbductionReport.find_by(witness_id: params[:witness_id], survivor_id: params[:survivor_id]) != nil
                    render json: {
                        status: 'ERROR',
                        message: "Witness already reported abduction"
                    }
                else
                ## Having a reference to survivor and witness objects, we make sure they exist
                    survivor = Survivor.find(params[:survivor_id])
                    witness = Survivor.find(params[:witness_id])
                    abductionReport = AbductionReport.new(abduction_report_params)
                    abductionReport.save
                    witnessesReportingAbduction = find_witnesses(params[:survivor_id], params[:witness_id])
                    if witnessesReportingAbduction >= 3 and survivor[:abducted] == false
                        survivor.update(abducted: true)
                    end
                    render json: {
                        status: 'SUCCESS',
                        data: abductionReport
                    }, status: :ok

                end

            end

            private
            def abduction_report_params
                params.permit(:survivor_id, :witness_id)
            end

            def find_witnesses(survivor_id, witness_id)
                survivorAbductionReports = AbductionReport.where('survivor_id == ?', survivor_id)
                witnessesReportingAbduction = survivorAbductionReports.map { |report| report[:witness_id] }
                witnessesReportingAbduction = witnessesReportingAbduction.uniq.count
                return witnessesReportingAbduction
            end
        end
    end
end
