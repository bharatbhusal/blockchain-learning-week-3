// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

struct User {
    uint roll;
    string name;
}

contract MappingContract {
    mapping(uint => User) public roll_to_name;
    User public bharat;

    constructor(uint roll, string memory name) {
        bharat.roll = roll;
        bharat.name = name;
    }

    function setter(uint roll) public {
        roll_to_name[roll] = bharat;
    }
}
