// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

contract DataTypes {
    uint8[6] public my_array = [1, 2, 3, 4, 5, 6];
    uint[] public my_dynamic_array;

    function setter(uint8 index, uint8 value) public {
        my_array[index] = value;
    }

    function length() public view returns (uint) {
        return my_array.length;
    }

    function push(uint value) public {
        my_dynamic_array.push(value);
    }

    function pop() public {
        my_dynamic_array.pop();
    }

    function len() public view returns (uint) {
        return my_dynamic_array.length;
    }
}
