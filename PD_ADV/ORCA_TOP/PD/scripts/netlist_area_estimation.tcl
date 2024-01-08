proc netlist_area {uti} {

###### To calculate macro_area ####
#


set t_m_area 0

foreach_in_collection macro [get_flat_cells -filter "is_hard_macro"] {
		  set macro_area [get_attribute [get_flat_cells $macro] area]
		  set t_m_area [expr $t_m_area + $macro_area]
}

puts "The total macro area is $t_m_area"


##### to calculate the std cell area
set s_c_area 0

foreach_in_collection macro [get_flat_cells -filter "is_hard_macro == false"] {
		  set macro_area [get_attribute [get_flat_cells $macro] area]
		  set s_c_area [expr $s_c_area + $macro_area]
}

puts "The total std_cell area is $s_c_area"


##### to get the total area of the netlist
set total_netlist_area [expr $t_m_area + $s_c_area]

puts "The total netlist area is $total_netlist_area"


##### The estimated core area for the block 
puts "The estimated core area is [expr $total_netlist_area / $uti ] "

}
