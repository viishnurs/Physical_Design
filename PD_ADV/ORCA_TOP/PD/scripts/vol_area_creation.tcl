proc va_create {d_name p_block g_band} {
		  set pb_bbox [get_attribute [get_placement_blockages $p_block] bbox]

		  set llxn [expr [lindex $pb_bbox 0 0] + $g_band]
		  set llyn [expr [lindex $pb_bbox 0 1] + $g_band]
		  set urxn [expr [lindex $pb_bbox 1 0] - $g_band]
		  set uryn [expr [lindex $pb_bbox 1 1] - $g_band]

		  set va_box [list [list $llxn $llyn] [list $urxn $uryn]]
		  set gb [list [list $g_band $g_band]]

		  create_voltage_area -power_domains $d_name -region $va_box -guard_band $gb
		  remove_placement_blockages [get_placement_blockages $p_block]
		
}
