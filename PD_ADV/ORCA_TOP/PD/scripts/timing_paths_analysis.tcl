set fh_read [open ./outputs/sv.txt r]  
set ufn ""
while {[gets $fh_read line] >=0} {
	if {[regexp -nocase {Startpoint:.*} $line]} {
	set sf [lindex $line 1]
	lassign [split $sf "/"] fn 
		set flag [lsearch $ufn $fn] 
			if {$flag == -1} {
			lappend ufn $fn 
			} 
	
	} 

} 

close $fh_read
set j 0
# I_CONTEXT_MEM
foreach a $ufn {
	set fh_read [open ./outputs/sv.txt r] 
	set i 0 
	while {[gets $fh_read line] >=0} {
		if {[regexp -nocase {Startpoint:.*} $line]} {
		set sf [lindex $line 1]
		lassign [split $sf "/"] fn 
			if {$a == $fn} {
			incr i 
			} 
		} 

	}
	set j [expr $i + $j]  
	puts "Family_name : $a \t Number : $i"
	close $fh_read
} 
