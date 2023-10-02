
proc va_estimation {uti ln} {
set t_area 0
foreach_in_collection cells [get_flat_cells I_RISC_CORE/*] {
		  set c_area [get_attribute [get_cells $cells] area]
		  set t_area [expr ($c_area + $t_area)]
}

puts "the total I-RISC_CORE area is $t_area"

set estimated_area [expr $t_area / $uti]
puts "The estimated area for vol_area is $estimated_area"

puts "the length of the vol_area is $ln, then its width will be [expr $estimated_area / $ln]"

}
