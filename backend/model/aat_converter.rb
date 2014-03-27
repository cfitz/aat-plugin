class AatConverter < Converter

  include ASpaceImport::CSVConvert

  def self.import_types(show_hidden = false)
      [
           {
             :name => "aat_subject_csv",
             :description => "Import AAT Subjects from a CSV file"
           }
      ]
  end


  def self.instance_for(type, input_file)
        if type == "aat_subject_csv"
             self.new(input_file)
        else
            nil
        end
  end

  def self.profile
    "Convert Subjects from a CSV file"
  end


  def self.configure
    {
      "subject_term" => "subject.term",
      "subject_vocabulary_id" => "subject.vocab_id",
      "subject_authority_id" => "subject.authority_id",
      'subject_term_type' => 'subject.term_type', 
      :subject => {
            :on_create => Proc.new { |data, obj|
               
                obj.terms = [{:term => data['term'], :term_type => data['term_type'], 
                              :vocabulary => '/vocabularies/1'}]
               
                obj.vocabulary = '/vocabularies/1'
            }
      }
    }
  end
end
