
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

namespace :increase do
  task :flooring_prices do
    CSV.open("./output/output.IIF", "w", { col_sep: "\t" }) do |output_csv|
      CSV.foreach("./source/price increase.IIF", { col_sep: "\t", headers: false }) do |csv|
        
        if csv[1] =~ VINYL_ITEM || csv[1] =~ CARPET_ITEM   
          old_price = csv[12].to_s.gsub(',', '').to_f
          markup    = 1+INCREASE_PERCENTAGE
          new_price = number_with_delimiter((old_price * markup).round(2))
          puts "#{csv[1]}\t#{csv[12]}\t#{new_price}"
          unless csv[1] =~ HDS_CUSTOMER
            csv[12] = new_price.to_s
          end
          output_csv << csv
        else
          puts "#{csv[1]}\t#{csv[12]}\t NO CHARGE"
          output_csv << csv
        end
      end
    end
  end
end