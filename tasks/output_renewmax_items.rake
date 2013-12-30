
require 'csv'
require './lib/helpers.rb'
include Helpers

# Omititions should be removed from the IIF file either before or after processing,
# but certainly before import.

# Pocessing may require many attempts. IIF files often have error rows which must 
# be removed as they are found. 


def write_iif_file_for_renewmax_item_output letter_number
  counter = 0
  CSV.open("./output/renewmax_item_output_#{letter_number}.IIF", "w", { col_sep: "\t" }) do |output_csv|
    CSV.foreach("./source/price increase.IIF", { col_sep: "\t", headers: false }) do |csv|
      counter = counter + 1
      
      if counter <= IIF_HEADER_ROWS
        output_csv << csv
      
      elsif csv[1] =~ RENEWMAX_ITEM && letter_number == csv[1][0] && csv[1] !~ HDS_CUSTOMER
        puts "#{csv[1]}"
        output_csv << csv
      end
    
    end
  
  end

end


namespace :output do
  task :renewmax_items do
    
    (0..9).each do |number|
      write_iif_file_for_renewmax_item_output(number.to_s)
    end

    ('A'..'Z').each do |letter|
      write_iif_file_for_renewmax_item_output(letter)
    end
    
  end # task

end # namespace