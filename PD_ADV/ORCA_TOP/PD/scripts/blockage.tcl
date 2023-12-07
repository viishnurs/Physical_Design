remove_placement_blockages -all

# Automatically insert placment blockage soft_blockage
derive_placement_blockages -force 


set c [get_attribute [get_placement_blockages] bbox]
puts $c
remove_placement_blockages -all

foreach co $c {
create_placement_blockage -boundary $co -type partial -blocked_percentage 75
}
