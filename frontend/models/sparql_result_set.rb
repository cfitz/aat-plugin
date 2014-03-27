require 'asutils'

class SparqlResultSet



  def initialize(response_body, query_string)
    @query_string = query_string
    @response = JSON.parse(response_body)
    @records = @response["results"]["bindings"].map { |record| { :uri => record["c"]["value"], :label => record["label"]["value"] } }
  end


  def each(&block)
    @records.each do |record|
      yield(record)
    end
  end

  def to_json
    ASUtils.to_json(:records => @records,
                    :query => @query_string )
  end

end
