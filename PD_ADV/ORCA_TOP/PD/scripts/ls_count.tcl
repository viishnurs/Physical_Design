
set i 0
set j 0
set t_area 0
set ls_cell [get_flat_cells -filter "is_level_shifter"]
foreach cell [get_attribute [get_flat_cells $ls_cell] ref_name] {
			
		  
		                                                                                   
		  regexp -nocase {([a-z]...)} $cell temp a
		 
		  if {$a == "LSUP"} {
					 incr i
		  } else {
					 incr j
		  }

}

foreach_in_collection cell_area [get_flat_cells $ls_cell] {
		set area [get_attribute [get_flat_cells $cell_area] area]
		set t_area [expr $area + $t_area]
		}

puts "the total area is $t_area"

set total [expr $i +  $j]

puts "The count of up_level shifter is $i"
puts "The count of down_level shifter is $j"
puts "the percentage of up_level is [expr ($i.00 / $total) * 100]" 
puts "the percentage of down_level is [expr ($j.00 / $total) * 100]"
