proc pins_name {} {

set all_cells [get_flat_cells -filter "is_hard_macro == false"]

set pin 0

foreach_in_collection std_pin $all_cells {
set pin_count [sizeof_collection [get_pins -of_objects [get_flat_cells $std_pin ]]]
set pin_name [get_object_name [get_flat_cells $std_pin ]]
set ref_name [get_attribute [get_flat_cells $std_pin ] ref_name]

 
  if {$pin_count > 7} {

 puts "name of the cell is :$pin_name\t count of the cell pins: $pin_count\t reference name of the cell: $ref_name"
  
 incr pin
}
}
 
 puts "the total count of cell which has pin count greater than 7 : $pin"
}
pins_name
