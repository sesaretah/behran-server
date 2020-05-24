class HomeController < ApplicationController

    def index
        if params[:slug] != 'v1' && !params[:slug].blank?
            shortner = Shortner.where(url: params[:slug]).first
            if !shortner.blank?
                if !shortner.items.blank? && shortner.items.count == 1
                    redirect_to shortner.items.first.href 
                else
                    redirect_to "/app.html#!/shortners/#{shortner.id}"
                end
            end
        end
    end
    
end