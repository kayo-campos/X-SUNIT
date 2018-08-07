## Side-function to make code cleaner
def get_percentage(maximumValue, acctualValue)
    return (100 * acctualValue) / maximumValue
end

def render_response(status, data, statusCode)
    render json: {
        status: status,
        data: data
    }, status: statusCode
end