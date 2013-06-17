
require 'csv'

task :default => [:increase_flooring_prices]


# Omititions should be removed from the IIF file either before or after processing,
# but certainly before import.

# Pocessing may require many attempts. IIF files often have error rows which must 
# be removed as they are found. 

INCREASE_PERCENTAGE = 0.073

task :increase_flooring_prices do
  
  CSV.open("output.IIF", "w", {col_sep: "\t"}) do |output_csv|
    CSV.foreach("price increase.IIF", { col_sep: "\t", headers: false }) do |csv|

      if ( csv[1] =~ /:V/ || csv[1] =~ /:C/ ) && csv[1] !~ /- HDS/ 
        new_price = (csv[12].to_s.gsub(',', '').to_f * (1+INCREASE_PERCENTAGE)).round(2).to_s
        puts "#{csv[1]}\t#{csv[12]}\t#{new_price}"
        csv[12] = new_price
      else
        puts "#{csv[1]}\t#{csv[12]}\t NO CHARGE"
        output_csv << csv
      end

    end
  end
    
end