##after copying files move to ICC2 SHELL then follow below things 
##creating. Library and ref libs##
create_lib -technology /home/tools/14nm_Libraries/tech/milkyway/saed14nm_1p9m_mw.tf ./outputs/works/chiptop
save_lib
####################search_path = providing the path the file which is getting used####
lappend search_path /home/tools/14nm_Libraries/stdcell_hvt/ndm/
lappend search_path /home/tools/14nm_Libraries/stdcell_lvt/ndm/
lappend search_path /home/tools/14nm_Libraries/stdcell_rvt/ndm/
lappend search_pathlose_b	 
lappend search_path /home/tools/14nm_Libraries/SAED14nm_EDK_SRAM_v_05072020/lib/sram/ndm/
lappend search_path /home/tools/14nm_Libraries/SAED14nm_EDK_SRAM_v_05072020/lib/sram_lp/ndm
##To set the reference lib used for the design##
Set ref_lib saed14hvt_frame_only.ndm saed14hvt_frame_timing_ccs.ndm saed14lvt_frame_only.ndm saed14lvt_frame_timing_ccs.ndm saed14rvt_frame_only.ndm saed14rvt_frame_timing_ccs.ndm saed14slvt_frame_only.ndm saed14slvt_frame_timing_ccs.ndm saed14_sram_1rw_frame_only.ndm saed14_sram_2rw_frame_only.ndm saed14_sram_lp_1rw_frame_only.ndm saed14_sram_lp_2rw_frame_only.ndm

Set_ref_libs  -ref_libs $ref_lib


####to list out the reference lib available in the design or not#
Report_ref_libs
Report_ref_libs >  ./outputs/reports/ref_lib.rpts
Save_lib
### after this create block initially and follow the same pnr procedure##
