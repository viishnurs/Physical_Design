set i 0
set j 0
set k 0
foreach_in_collection a [get_flat_cells] {
	set ref [get_attribute [get_cells $a] ref_name]
	if {[regexp -nocase {HVT} $ref]} {
		incr i
	} elseif {[regexp -nocase {RVT} $ref]} {
		incr j
	} elseif {[regexp -nocase {LVT} $ref]} {
		incr k
	}
}

puts "Number of HVT cells : $i"
puts "Number of RVT cells : $j"
puts "Number of LVT cells : $k"

set total [expr $i +  $j + $k]
puts "total cells : $total"

puts "the percentage of HVT cells is [expr ($i.00/$total) * 100]"
puts "the percentage of RVT cells is [expr ($j.00/$total) * 100]"
puts "the percentage of LVT cells is [expr ($k.00/$total) * 100]"
