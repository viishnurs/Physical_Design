if {![file exist ./outputs/floorplan/reports/macro_detail.txt]} {[sh touch ./outputs/floorplan/reports/macro_detail.txt]}

set file1 [open ./outputs/floorplan/reports/macro_detail.txt w+]

foreach_in_collection macro [get_flat_cells -filter "is_hard_macro"] {
set macro_name [get_object_name $macro]
set height [get_attribute [get_flat_cells $macro] height]
set width [get_attribute [get_flat_cells $macro] width]
set area [get_attribute [get_flat_cells $macro] area]
puts $file1 "the macro name is $macro_name\tit's height is $height\tit's width is $width\t area is $area\tpercent of area occupied is :"
 }
 
