// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

contract Loops{
    uint[10] public uint_array;

    function loop() public {
         for (uint i = 0; i< uint_array.length; i++) {
            uint_array[i] = i**2;
        }
    }

}