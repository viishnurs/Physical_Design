
#source ./scripts/vol_area_creation.tcl
#va_create PD_RISC_CORE pb_0 3.344


### placement of boundary cells

create_keepout_margin -type hard -outer {2 2 2 2 } [get_flat_cells -filter "is_hard_macro"]

remove_cells [get_flat_cells *boundary* -all ]
remove_cells [get_flat_cells *tapfiller* -all ]

set_boundary_cell_rules -left_boundary_cell saed32_hvt|saed32_hvt_std/DCAP_HVT -right_boundary_cell saed32_hvt|saed32_hvt_std/DCAP_HVT -at_va_boundary

compile_boundary_cells

check_boundary_cells


#####   placement of TAP cells 

create_tap_cells -lib_cell saed32_hvt|saed32_hvt_std/DCAP_HVT -distance 30 -pattern stagger -skip_fixed_cells
check_legality


#save_block -as boundary_tap_placement
save_block -as floor_plan_main
######## SANITY CHECKS #########33

check_mv_design
report_utilization
