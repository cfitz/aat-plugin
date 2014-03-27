ArchivesSpace::Application.routes.draw do

  match('/plugins/aat' => 'aat#index', :via => [:get])
  match('/plugins/aat/search' => 'aat#search', :via => [:get])
  match('/plugins/aat/import' => 'aat#import', :via => [:post])

end
