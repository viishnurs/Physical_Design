
lappend search_path /home/vlsiguru/PHYSICAL_DESIGN/TRAINER2/PD/PROJECTS/RISC/ref/design_data /home/vlsiguru/PHYSICAL_DESIGN/TRAINER2/PD/PROJECTS/RISC/ORCA_TOP/scripts_block/lcrm_setup /home/vlsiguru/PHYSICAL_DESIGN/TRAINER2/PD/PROJECTS/RISC/ORCA_TOP/scripts_block/rm_setup /home/vlsiguru/PHYSICAL_DESIGN/TRAINER2/PD/PROJECTS/RISC/ORCA_TOP/scripts_block/rm_icc_scripts /home/vlsiguru/PHYSICAL_DESIGN/TRAINER2/PD/PROJECTS/RISC/ORCA_TOP/scripts_block/rm_icc_zrt_scripts /home/vlsiguru/PHYSICAL_DESIGN/TRAINER2/PD/PROJECTS/RISC/ORCA_TOP/scripts_block/rm_icc_dp_scripts /home/vlsiguru/PHYSICAL_DESIGN/TRAINER2/PD/PROJECTS/RISC/ref/SAED32_2012-12-25/lib/stdcell_lvt/db_nldm /home/vlsiguru/PHYSICAL_DESIGN/TRAINER2/PD/PROJECTS/RISC/ref/SAED32_2012-12-25/lib/stdcell_hvt/db_nldm /home/vlsiguru/PHYSICAL_DESIGN/TRAINER2/PD/PROJECTS/RISC/ref/SAED32_2012-12-25/lib/sram_lp/db_nldm /home/vlsiguru/PHYSICAL_DESIGN/TRAINER2/PD/PROJECTS/RISC/ref/SAED32_2012-12-25/tech/milkyway /home/vlsiguru/PHYSICAL_DESIGN/TRAINER2/PD/PROJECTS/RISC/ref/SAED32_2012-12-25/lib/stdcell_lvt/milkyway /home/vlsiguru/PHYSICAL_DESIGN/TRAINER2/PD/PROJECTS/RISC/ref/SAED32_2012-12-25/lib/stdcell_hvt/milkyway /home/vlsiguru/PHYSICAL_DESIGN/TRAINER2/PD/PROJECTS/RISC/ref/SAED32_2012-12-25/lib/sram_lp/milkyway /home/vlsiguru/PHYSICAL_DESIGN/TRAINER2/PD/PROJECTS/RISC/ORCA_TOP/scripts_block/rm_icc_scripts /home/vlsiguru/PHYSICAL_DESIGN/TRAINER2/PD/PROJECTS/RISC/ORCA_TOP/other_scripts /home/vlsiguru/PHYSICAL_DESIGN/TRAINER2/PD/PROJECTS/RISC/ref/SAED32_2012-12-25/lib/stdcell_rvt/milkyway /home/vlsiguru/PHYSICAL_DESIGN/TRAINER2/PD/PROJECTS/RISC/ref/SAED32_2012-12-25/lib/stdcell_rvt/db_nldm /home/tools/libraries/28nm/lib/stdcell_rvt/db_nldm /home/tools/libraries/28nm/lib/stdcell_rvt/milkyway

set_app_var link_library "* saed32lvt_ss0p75v125c.db saed32rvt_ss0p75v125c.db saed32hvt_ss0p75v125c.db  saed32hvt_ulvl_ss0p95v125c_i0p75v.db saed32lvt_ulvl_ss0p95v125c_i0p75v.db saed32rvt_ulvl_ss0p95v125c_i0p75v.db saed32hvt_dlvl_ss0p75v125c_i0p95v.db saed32rvt_dlvl_ss0p75v125c_i0p95v.db saed32lvt_dlvl_ss0p75v125c_i0p95v.db saed32sramlp_ss0p75v125c_i0p75v.db" 


read_verilog /home/vishnu/PD_Adv_Aug23/ORCA_TOP/PRIME_TIME/inputs/routed_netlist.v

set link_create_black_boxes false
current_design ORCA_TOP

list_design
link_design ORCA_TOP

set_eco_options -physical_icc2_lib ./../PD/outputs/work/ORCA_TOP.nlib -physical_icc2_blocks route_opt_done 

load_upf ./../PD/inputs/ORCA_TOP.upf
read_sdc /home/vishnu/PD_Adv_Aug23/ORCA_TOP/PRIME_TIME/inputs/orca_ss_125c.sdc

define_scaling_lib_group { saed32lvt_ss0p75v125c.db  saed32lvt_ss0p95v125c.db}
define_scaling_lib_group { saed32hvt_ss0p75v125c.db  saed32hvt_ss0p95v125c.db}
define_scaling_lib_group { saed32rvt_ss0p75v125c.db  saed32rvt_ss0p95v125c.db}
define_scaling_lib_group {saed32sramlp_ss0p75v125c_i0p75v.db saed32sramlp_ss0p95v125c_i0p95v.db}

read_parasitics ./../STARRC/outputs/SPEF/Cmax_125c.spef -keep_capacitive_coupling
set si_enable_analysis true 
set si_xtalk_composite_aggr_mode statistical
check_eco
update_timing -full

save_session ./outputs/db/ORCA_TOP.session
