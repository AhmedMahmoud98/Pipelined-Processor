#!/usr/bin/tclsh

### Parameters
set code_file_path "Test Cases/OneOperand.asm"; list
set memory_file_path "ram.txt"; list
set memory_sim_path "CPU/memory_controller/main_memory/Mem"; list

### Run the assembler to generate ram contents
if {[catch { exec python Assembler/assembler.py $code_file_path $memory_file_path }]} {
    exec python3 Assembler/assembler.py $code_file_path $memory_file_path
}


### Initialize simulation
vsim CPU  
add wave -unsigned *
#add wave -unsigned CPU/Fetch_Stage/fetch_forwarding_unit/*
#add wave -unsigned CPU/Execute_Stage/EX_FORW_UNIT/*
add wave -decimal memory_controller/main_memory/Mem
add wave -decimal memory_controller/instruction_cache/cache
add wave -decimal memory_controller/data_cache/cache
add wave -unsigned Decode_Stage/registers/Register_File

# Remove numeric std warnings before initialization
set NumericStdNoWarnings 1; list
run 0
set NumericStdNoWarnings 0; list

############################
add wave -radix unsigned Fetch_Stage/pc_out
#add wave -radix unsigned Fetch_Stage/pc_in
#add wave Fetch_Stage/pc_enable
#add wave Fetch_Stage/instruction_read
#add wave Fetch_Stage/RET_Fetch
#add wave Fetch_Stage/int_internal
#add wave Execute_Stage/*
############################


### Load data memory
set ram_contents_file [open $memory_file_path]; list
set ram_contents [read $ram_contents_file]; list
set ram_contents [string trim $ram_contents]; list
set ram_contents [split $ram_contents "\n"]; list
set end_address [expr {[llength $ram_contents] - 1}]; list
mem load -filldata $ram_contents $memory_sim_path -endaddress $end_address


### Initialize CLK and RST
force CLK 1 0, 0 50 -r 100
force RST 1
force INT 0
force Input_Port 10#17
run 100
force RST 0
run 2000

