Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :survivors do
        resource :location, only: [:show, :update]
        resources :abduction_reports, only: [:create]
      end
      get '/general-information' => 'survivors#general_information'
    end
  end
end
