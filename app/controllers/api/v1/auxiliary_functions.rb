## Side-function to make code cleaner
def render_response(status, data, statusCode)
    render json: {
        status: status,
        data: data
    }, status: statusCode
end