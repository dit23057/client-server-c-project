set ns [new Simulator]
set nf [open lab3.nam w]
$ns namtrace-all $nf
set xf [open lab3.tr w]
$ns trace-all $xf
proc finish {} {
global ns nf xf
$ns flush-trace
close $nf
close $xf
exit 0
}

for {set i 0} {$i < 12} {incr i} {
set n($i) [$ns node]
}

for {set i 0} {$i < 12} {incr i} {
 $ns duplex-link $n($i) $n([expr ($i+1)%12]) 1Mb 10ms DropTail
}

set udp0 [new Agent/UDP]
$ns attach-agent $n(0) $udp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 1000
$cbr0 set interval_ 0.02
$cbr0 attach-agent $udp0
set sink0 [new Agent/LossMonitor]
$ns attach-agent $n(4) $sink0
$ns connect $udp0 $sink0
$ns at 0.5 "$cbr0 start"
$ns at 5.5 "$cbr0 stop"

$ns rtmodel-at 2.0 down $n(2) $n(3)
$ns rtmodel-at 3.0 up $n(2) $n(3)

$ns rtproto DV





$ns at 8.0 "finish"
$ns run
