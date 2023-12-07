set fh_read [open ./outputs/sv_aro.txt r] 
set spa 0 
set flag 0 
set it 0 
set pin_list "" 
while {[gets $fh_read line] >= 0} {
	if {[regexp -nocase {startpoint:} $line]} {
		incr it 	
		# puts "path : $it"
		set spa 1
		continue 
	} 

	if {[regexp -nocase {clock network delay } $line]} {
		set flag 1 
		continue 
	} 

	if {[regexp -nocase {data arrival time} $line] } {
		set spa 0
		set flag 0 
	} 

	if {($spa == 1) && ($flag == 1)} {
		if {$line == ""} { 
			continue 
		} 
		set pn [lindex $line 0] 
	 	set cell_name [get_cells -of_objects [get_pins $pn] ]
		set av [get_attr [get_cells $cell_name] is_combinational]
		if {$av == "true"} {             
			set search_flag [lsearch $pin_list $pn]
		 
 		if {$search_flag == -1} {
		lappend pin_list $pn 
		set nop [sizeof_collection [get_timing_paths -through $pn -max_paths 91 -slack_lesser_than 0]] 
		if {$nop >= 5} {
		set ref_nn [get_attribute [get_cell -of_object [get_pin $pn] ] 	ref_name ] 
			if {[regexp -nocase {HVT|RVT} $ref_nn]} {
				puts "$pn $nop $ref_nn" 
			 } 
		} 
		} 	 
	} 

} 
}

