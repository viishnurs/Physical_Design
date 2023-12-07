proc upsize_cell nn  {
set dn [get_object_name [get_cells -of_objects [get_pins -filter "direction ==out"  [all_connected $nn -leaf]]]]
set rn [get_attribute [get_cell $dn] ref_name]
puts "drive_name : $dn \t old_ref_name : $rn" 
regexp -nocase {(.+X)([0-9]+)(_.+)} $rn temp a b c
		if {($b == 0) || ($b == 1)} { 
		set b [expr $b + 1] 
	} else { 
		set b [expr $b * 2] 
	} 
set nrn $a$b$c
size_cell $dn $nrn
set nrn [get_attribute [get_cell $dn] ref_name]
puts "drive_name : $dn \t new_ref_name : $nrn" 
} 

set m 0 
set n 0
set i 1
set fh_read [open ./outputs/mtv.txt r] 

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

puts "\n number of cells upsized $m" 
puts "number of cells failed to upsize $n"
close $fh_read  
