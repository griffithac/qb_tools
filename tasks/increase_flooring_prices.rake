
require 'csv'
require './lib/helpers.rb'
include Helpers

# Omititions should be removed from the IIF file either before or after processing,
# but certainly before import.

# Pocessing may require many attempts. IIF files often have error rows which must 
# be removed as they are found. 

INCREASE_PERCENTAGE = 0.073
HDS_CUSTOMER        = /- HDS/
CARPET_ITEM         = /:C/
VINYL_ITEM          = /:V/
RENEWMAX_ITEM       = /:R/
IIF_HEADER_ROWS     = 21


def write_iif_file_for letter_number
  counter = 0
  CSV.open("./output/output_#{letter_number}.IIF", "w", { col_sep: "\t" }) do |output_csv|
    CSV.foreach("./source/price increase.IIF", { col_sep: "\t", headers: false }) do |csv|
      counter = counter + 1
      
      if counter <= IIF_HEADER_ROWS
        output_csv << csv
      
      elsif (csv[1] =~ VINYL_ITEM || csv[1] =~ CARPET_ITEM) && 
            (csv[12].to_s.gsub(',', '').to_i != 0 ) && 
            letter_number == csv[1][0]
        
        old_price = csv[12].to_s.
        gsub(',', '').to_f
        markup    = 1+INCREASE_PERCENTAGE
        new_price = number_with_delimiter((old_price * markup).round(2))
        puts "#{csv[1]}\t#{csv[12]}\t#{new_price}"
        csv[12] = new_price.to_s if csv[1] !~ HDS_CUSTOMER 
        output_csv << csv
      end
    
    end
  
  end

end


namespace :increase do
  task :flooring_prices do
    
    (0..9).each do |number|
      write_iif_file_for(number.to_s)
    end

    ('A'..'Z').each do |letter|
      write_iif_file_for(letter)
    end
    
  end # task

end # namespace