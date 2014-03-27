require 'net/http'

require_relative 'sparql_query'

class SparqlSearcher

  class SparqlSearchException < StandardError; end


  def initialize(base_url)
    @base_url = base_url
  end


  def default_params
    {}
  end



  def search(query, page, records_per_page)
    uri = URI(@base_url)
    
    uri.query = URI.encode_www_form(default_params) + "&query=#{query.to_s}"
    response = Net::HTTP.get_response(uri)

    if response.code != '200'
      raise SparqlSearchException.new("Error during Sparql search: #{uri.to_s} #{response.body}")
    end
    SparqlResultSet.new(response.body, query.query_string)
  end

  def results_to_csv_file(query)
    tempfile = ASUtils.tempfile('aat_import')

    tempfile.write("subject_vocabulary_id,subject_authority_id,subject_term, subject_term_type\n")

    query.each_pair do |key,val|
      tempfile.write("0, #{key}, #{val}, Topical\n")
    end

    tempfile.flush
    tempfile.rewind

    return tempfile
  end

end
