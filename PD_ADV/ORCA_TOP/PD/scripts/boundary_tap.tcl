### placement of boundary cells

set_boundary_cell_rules -left_boundary_cell saed32_hvt|saed32_hvt_std/DCAP_HVT -right_boundary_cell saed32_hvt|saed32_hvt_std/DCAP_HVT -at_va_boundary

compile_boundary_cells

check_boundary_cells


#####   placement of TAP cells 

create_tap_cells -lib_cell saed32_hvt|saed32_hvt_std/DCAP_HVT -distance 30 -pattern stagger -skip_fixed_cells
check_leagality


save_block -as boundary_tap_placement


### SANITY CHECKS 

check_mv_design
create_utilization -configration -include all fp
report_utilization -config fp
