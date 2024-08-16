# Initialize variables
set scenario ""
set timing_group ""
set critical_path_slack ""
set total_negative_slack ""
set violating_paths ""

# Initialize the table header
puts "Scenario\t\tTiming Path Group\tNo. of Violating Paths\tTotal Negative Slack\tCritical Path Slack\n"
puts "--------------------------------------------------------------------------------------------------------------------------"



# Open the report file
set file [open report_qor.rpt r]

# Process each line of the report
while {[gets $file line] != -1} {

    # Check if the line contains a Scenario
    if {[regexp {^Scenario\s+'(.+)'$} $line -> scenario_name]} {
        set scenario $scenario_name
    }

    # Check if the line contains a Timing Path Group
    if {[regexp {^Timing Path Group\s+'(.+)'$} $line -> group_name]} {
        set timing_group $group_name
    }

    # Check if the line contains Critical Path Slack
    if {[regexp {^Critical Path Slack:\s+([\d\.]+)$} $line -> slack]} {
        set critical_path_slack $slack
    }

    # Check if the line contains Total Negative Slack
    if {[regexp {^Total Negative Slack:\s+([\d\.]+)$} $line -> negative_slack]} {
        set total_negative_slack $negative_slack
    }

    # Check if the line contains No. of Violating Paths
    if {[regexp {^No\. of Violating Paths:\s+(\d+)$} $line -> paths]} {
        set violating_paths $paths
            puts "$scenario\t\t$timing_group\t\t\t$violating_paths\t\t\t$total_negative_slack\t\t\t$critical_path_slack"
            
        }
    }

# Close the report file
close $file
