match '/dropbox/authorize', :to => "dropbox#authorize", :as => :dropbox_authorize, :via => [:get, :post]
