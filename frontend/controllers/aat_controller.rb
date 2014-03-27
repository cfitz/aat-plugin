require 'sparql_searcher'
require 'sparql_query'
require 'securerandom'

class AatController < ApplicationController

  set_access_control "update_agent_record" => [:search, :index, :import]

  def index
  end


  def search
    query = SparqlQuery.term_search(params[:query])
    render :json => searcher.search(query, params[:page].to_i, params[:records_per_page].to_i).to_json
  end


  def import
    export_file = searcher.results_to_csv_file(params[:terms])
    
    begin
      job = Job.new("aat_subject_csv",
                    {"aat_subjects_#{SecureRandom.uuid}" => export_file})

      response = job.upload
      render :json => {'job_uri' => url_for(:controller => :jobs, :action => :show, :id => response['id'])}
    rescue
      render :json => {'error' => $!.to_s}
    end
  end


  private

  def searcher
    SparqlSearcher.new('http://vocab.getty.edu/sparql.json')
  end

end
