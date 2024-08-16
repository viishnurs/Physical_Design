set keywords [list "Scenario" "Timing Path Group" "No. of Violating Paths:" "Total Negative Slack:" "Critical Path Slack:"]

#set filename report_qor.rpt 
set fileId [open report_qor.rpt r]

# Read the file line by line
while {[gets $fileId line] >= 0} {
    # Check each keyword
    foreach keyword $keywords {
        if {[string match "*$keyword*" $line]} {
            puts $line
        }
    }
}

# Close the file
close $fileId
