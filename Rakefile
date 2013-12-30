FLOORING_INCREASE_PERCENTAGE = 0.073
HDS_CUSTOMER                 = /- HDS/
CARPET_ITEM                  = /:C/
VINYL_ITEM                   = /:V/
RENEWMAX_ITEM                = /:R/
RENEWMAX_TS_ITEM             = /:R T/
IIF_HEADER_ROWS              = 21

def markups
  {
    15.6 => 1.121794,
    15.8 => 1.107595,
    17.8 => 1.095505,
    16.5 => 1.060606,
    18.5 => 1.054054 
  }
end




load './tasks/increase_flooring_prices.rake'
load './tasks/output_renewmax_items.rake'

task :default => [:tasks]

task :tasks do
  puts 'please indicate a task to run'
end

