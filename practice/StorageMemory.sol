// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

contract StorageMemory{
    string[] public student = ["Bharat", "Naina", "Tanisha"];

//memory creates a copy of data structure.
    function mem() public view {
        string[] memory s1 = student;
        s1[0] = "Ravi";
    }
//storage creates an address to existing data structure.
    function sto() public {
        string[] storage s2 = student;
        s2[0] = "Ravi";
    }
}