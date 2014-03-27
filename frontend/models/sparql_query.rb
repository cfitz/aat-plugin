require 'uri'

class SparqlQuery

  def self.term_search(query_string)
    new(query_string)
  end


  def self.lccn_search(lccns)
    new(lccns.join(" "), ['local.LCCN'])
  end


  def initialize(query_string, limit = 25 )
    @query = build_query(query_string, limit)
  end


  def query_string
    @query
  end

  def build_query(query_string, limit = 25)
<<EOF
  PREFIX gvp: <http://vocab.getty.edu/ontology#>
  PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
  PREFIX luc: <http://www.ontotext.com/owlim/lucene#>
  SELECT ?c ?label WHERE {
  ?c rdf:type gvp:Concept ;
  skos:inScheme aat: ;
  gvp:prefLabelGVP/xl:literalForm ?label ;
  luc:term "#{query_string.gsub(' ', '+')}" } LIMIT #{limit.to_s} 
EOF

  end


  def to_s
    URI.escape(@query) 
  end

end
