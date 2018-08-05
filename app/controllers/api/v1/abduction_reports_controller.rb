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
                else
                    survivor = Survivor.find(params[:survivor_id])
                    witness = Survivor.find(params[:witness_id])
                    abductionReport = AbductionReport.new(abductionReport_params)
                    abductionReport.save
                    witnessesReportingAbduction = findWitnesses(params[:survivor_id], params[:witness_id])
                    if witnessesReportingAbduction >= 3 and survivor[:abducted] == false
                        survivor.update(abducted: true)
                    end
                    render json: {
                        status: 'SUCCESS',
                        survivor: survivor,
                        abductionReport: abductionReport,
                        witnessesReportingAbduction: witnessesReportingAbduction
                    }
                end
            end

            private
            def abductionReport_params
                params.permit(:survivor_id, :witness_id)
            end

            def findWitnesses(survivor_id, witness_id)
                survivorAbductionReports = AbductionReport.where('survivor_id == ?', survivor_id)
                witnessesReportingAbduction = survivorAbductionReports.map { |report| report[:witness_id] }
                witnessesReportingAbduction = witnessesReportingAbduction.uniq.count
                return witnessesReportingAbduction
            end
        end
    end
end
