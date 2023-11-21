// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

contract ByteArrya{
    bytes2 public b2;
    bytes3 public b3;
    bytes public b_dynamic;

    function setter()public {
        b2 = '~';
        b3 = '8';
    }
    
    function push() public {
        b_dynamic.push('.');
    }

    function pop() public {
        b_dynamic.pop();
    }

    function len() public view returns(uint) {
        return b_dynamic.length;
    }
}