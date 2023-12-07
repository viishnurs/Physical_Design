proc upsize_cell nn  {
set dn [get_object_name [get_pins -filter "direction ==out"  [all_connected $nn -leaf]]]
set bn [get_object_name [insert_buffer $dn NBUFFX8_HVT]] 
 set dpc [lindex [get_attribute [get_pins $dn] bbox] 0]
 move_objects -to $dpc [get_cells $bn]
puts $bn 
} 


set m 0 
set n 0
set i 1
set fh_read [open ./outputs/mcv.txt r] 
while {[gets $fh_read line] >= 0} {
	if {[llength $line] == 5} {
		puts "\n iteration $i" 
		set net_name [lindex $line 0] 
		set flag [catch {upsize_cell $net_name}]   
			if {$flag == 0} {
				incr m 
				puts "upsized successfully" 
			} else {
				incr n 
				puts "upsize failed" 

			} 
	incr i 
	}
} 

puts "number of cells insterted $m" 
puts "number of cells failed to insert $n"
close $fh_read  

# legalize_placement -inc
