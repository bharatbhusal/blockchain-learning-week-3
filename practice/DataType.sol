// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

contract DataTypes{
    uint8[] public my_array = [1, 2, 3, 4, 5, 6];

function setter(uint8 index, uint8 value) public {
    my_array[index]= value;
}

function length() public view returns(uint){
    return my_array.length;
}
}