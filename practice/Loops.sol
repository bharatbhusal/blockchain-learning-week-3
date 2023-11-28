// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

contract Loops {
    uint[10] public uint_array;

    function loopWithFor() public {
        for (uint i = 0; i < uint_array.length; i++) {
            uint_array[i] = i ** 2;
        }
    }

    function loopWithWhile() public {
        uint i = 0;
        while (i < uint_array.length) {
            uint_array[i] = i ** 2;
            i++;
        }
    }
}
