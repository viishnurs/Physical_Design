#################################################################################
#### Created by :VISHNU RS
####	Description :
####
##################################################################################
## reset all the placement
reset_placement
remove_placement_blockages -all
gui_explore_logic_hierarchy -remove


## setting of app_options 
set_app_options -list { \
		  plan.macro.macro_place_only true \
		  plan.macro.auto_macro_array_max_num_cols 3 \
		  plan.macro.auto_macro_array_max_num_rows 3 \
		  plan.macro.align_pins_on_parallel_edges true \
		  plan.macro.grouping_by_hierarchy true \
		  plan.macro.congestion_iters 5 \
		  plan.macro.spacing_rule_widths {10u 10u} \
		  plan.macro.spacing_rule_heights {10u 10u} \
		  plan.macro.auto_buffer_channels true \
		  plan.macro.max_buffer_stack_width 200u \
		  plan.macro.buffer_channel_width 2u \
		  plan.macro.min_macro_keepout 1.672u \
}

create_placement	-floorplan
