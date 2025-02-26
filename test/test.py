#!/usr/bin/env python3
import os
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

@cocotb.test()
async def test_priority_encoder(dut):
    # Start the clock
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())
    
    # Reset values
    dut.ena.value = 1
    dut.rst_n.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    
    # Release reset
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 5)
    
    # Test all the priority cases for ui_in (highest bit has priority)
    test_inputs = [
        {"ui_in": 0b10000000, "uio_in": 0, "expected": 0x15},  # ui_in[7] = 1
        {"ui_in": 0b01000000, "uio_in": 0, "expected": 0x14},  # ui_in[6] = 1
        {"ui_in": 0b00100000, "uio_in": 0, "expected": 0x13},  # ui_in[5] = 1
        {"ui_in": 0b00010000, "uio_in": 0, "expected": 0x12},  # ui_in[4] = 1
        {"ui_in": 0b00001000, "uio_in": 0, "expected": 0x11},  # ui_in[3] = 1
        {"ui_in": 0b00000100, "uio_in": 0, "expected": 0x10},  # ui_in[2] = 1
        {"ui_in": 0b00000010, "uio_in": 0, "expected": 0x09},  # ui_in[1] = 1
        {"ui_in": 0b00000001, "uio_in": 0, "expected": 0x08},  # ui_in[0] = 1
        {"ui_in": 0, "uio_in": 0b10000000, "expected": 0x07},  # uio_in[7] = 1
        {"ui_in": 0, "uio_in": 0b01000000, "expected": 0x06},  # uio_in[6] = 1
        {"ui_in": 0, "uio_in": 0b00100000, "expected": 0x05},  # uio_in[5] = 1
        {"ui_in": 0, "uio_in": 0b00010000, "expected": 0x04},  # uio_in[4] = 1
        {"ui_in": 0, "uio_in": 0b00001000, "expected": 0x03},  # uio_in[3] = 1
        {"ui_in": 0, "uio_in": 0b00000100, "expected": 0x02},  # uio_in[2] = 1
        {"ui_in": 0, "uio_in": 0b00000010, "expected": 0x01},  # uio_in[1] = 1
        {"ui_in": 0, "uio_in": 0b00000001, "expected": 0x00},  # uio_in[0] = 1
        {"ui_in": 0, "uio_in": 0, "expected": 0xF0},          # Default case
    ]
    
    # Test multiple priority cases
    for test in test_inputs:
        dut.ui_in.value = test["ui_in"]
        dut.uio_in.value = test["uio_in"]
        await Timer(2, units="ns")  # Wait for combinational logic to settle
        
        actual = dut.uo_out.value
        expected = test["expected"]
        
        assert actual == expected, f"Test failed! Expected: {expected:02x}, Got: {actual:02x}, ui_in={test['ui_in']:08b}, uio_in={test['uio_in']:08b}"
        
        await ClockCycles(dut.clk, 1)
    
    # Test priority (highest bit wins)
    dut.ui_in.value = 0b01010101
    dut.uio_in.value = 0b10101010
    await Timer(2, units="ns")
    assert dut.uo_out.value == 0x14, f"Priority test failed! Expected: 0x14, Got: {dut.uo_out.value:02x}"
    
    # All bits high - highest bit should win
    dut.ui_in.value = 0xFF
    dut.uio_in.value = 0xFF
    await Timer(2, units="ns")
    assert dut.uo_out.value == 0x15, f"All-high test failed! Expected: 0x15, Got: {dut.uo_out.value:02x}"
    
    print("All tests passed!")
