
####### to calculate the macro area ###########
#
#to give the input of utilisation factor we should use proc becz it will help us to give input of utilisation factor 
#
proc netlist_area {uti} {

set total_macro_area 0

foreach_in_collection macro [get_flat_cells -filter "is_hard_macro"] {
			set macro_area [get_attribute [get_flat_cells $macro] area]

			set total_macro_area [expr $total_macro_area + $macro_area ]
	
}

puts " the total area of macro is $total_macro_area"
############# to calculate the std cell area that is expect total_macro_aree so is_hard_macro == false
set  std_cell_area 0

foreach_in_collection macro [get_flat_cells -filter "is_hard_macro == false "] {
			set macro_area [get_attribute [get_flat_cells $macro] area]

			set std_cell_area [expr $std_cell_area + $macro_area]

}

puts "the total std cell area is $std_cell_area"

############# to get the total area of netlist #######33

set total_netlist_area [expr $total_macro_area + $std_cell_area]

puts "the total netlist area is $total_netlist_area"

#########to estimate core area #############3
#
puts "the estimated core area is [expr $total_netlist_area / $uti]"


}
