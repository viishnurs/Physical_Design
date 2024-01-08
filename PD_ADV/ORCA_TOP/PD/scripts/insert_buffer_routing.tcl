proc upsize_cell nn  {
set nl [get_attribute [get_nets $nn] dr_length]
	if {$nl <= 300} {
		set nld [expr $nl / 2] 
		add_buffer_on_route [get_nets $nn] -repeater_distance $nld -lib_cell NBUFFX2_HVT
	}  else { 
		add_buffer_on_route [get_nets $nn] -repeater_distance 150 -lib_cell NBUFFX2_HVT 
	} 

} 


set m 0 
set n 0
set i 1
set fh_read [open ./outputs/mcv_af.txt r] 
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

puts "number of cells inserted $m" 
puts "number of cells failed to insert $n"
close $fh_read  

# legalize_placement -incremental
