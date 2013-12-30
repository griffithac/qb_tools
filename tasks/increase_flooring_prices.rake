
require 'csv'
require './lib/helpers.rb'
include Helpers

# Omititions should be removed from the IIF file either before or after processing,
# but certainly before import.

# Pocessing may require many attempts. IIF files often have error rows which must 
# be removed as they are found. 


def write_iif_file_for_increased_flooring_prices letter_number
  counter = 0
  CSV.open("./output/flooring_increase_output_#{letter_number}.IIF", "w", { col_sep: "\t" }) do |output_csv|
    CSV.foreach("./source/price_increase.IIF", { col_sep: "\t", headers: false }) do |csv|
      counter = counter + 1
      
      if counter <= IIF_HEADER_ROWS
        output_csv << csv
      
      elsif (csv[1] =~ VINYL_ITEM || csv[1] =~ CARPET_ITEM) && 
            (csv[12].to_s.gsub(',', '').to_i != 0 ) && 
            letter_number == csv[1][0]
        
        old_price = csv[12].to_s.
        gsub(',', '').to_f
        markup    = 1+FLOORING_INCREASE_PERCENTAGE
        new_price = number_with_delimiter((old_price * markup).round(2))
        puts "#{csv[1]}\t#{csv[12]}\t#{new_price}"
        csv[12] = new_price.to_s if csv[1] !~ HDS_CUSTOMER 
        output_csv << csv
      end
    
    end
  
  end

end


def get_markup current_markup, item, old_rate
  if item.split(':')[1] == 'R'
    unless markups[old_rate.to_f].nil?
      markups[old_rate.to_f]
    else
      1.0
    end
  else
    current_markup
  end
end

def write_iif_file_for_increased_renewmax_prices letter_number
  counter = 0
  markup = 1.0

  CSV.open("./output/renewmax_increase_output_#{letter_number}.IIF", "w", { col_sep: "\t" }) do |output_csv|
    CSV.foreach("./source/price_increase.IIF", { col_sep: "\t", headers: false }) do |csv|
      
      puts csv[1]
      counter = counter + 1
      
      if counter <= IIF_HEADER_ROWS
        output_csv << csv
      
      elsif csv[1] =~ RENEWMAX_ITEM &&  
            csv[1] !~ RENEWMAX_TS_ITEM &&
            csv[1] !~ HDS_CUSTOMER &&
            letter_number == csv[1][0]

        old_price = csv[12].nil? ? 0.0 : csv[12].to_s.gsub(',', '').to_f
        markup = get_markup(markup, csv[1], csv[12])
        new_price = number_with_delimiter((old_price * markup).round(2))
        puts "#{csv[1]}\t#{csv[12]}\t#{new_price}"
        csv[12] = new_price
        output_csv << csv
      end
    
    end
  
  end

end


namespace :increase do
  task :flooring_prices do
    
    (0..9).each do |number|
      write_iif_file_for_increased_flooring_prices(number.to_s)
    end

    ('A'..'Z').each do |letter|
      write_iif_file_for_increased_flooring_prices(letter)
    end
    
  end # task

  task :renewmax_prices do
    (0..9).each do |number|
      write_iif_file_for_increased_renewmax_prices(number.to_s)
    end

    ('A'..'Z').each do |letter|
      write_iif_file_for_increased_renewmax_prices(letter)
    end
  end

end # namespace