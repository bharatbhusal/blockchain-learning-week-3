// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;
struct Card {
    string name;
    uint age;
    string roll;
}

contract Identity {
    Card public me;

    constructor(string memory _name, uint _age, string memory _roll) {
        me.name = _name;
        me.age = _age;
        me.roll = _roll;
    }

    function getName() public view returns (string memory) {
        return me.name;
    }

    function getAge() public view returns (uint) {
        return me.age;
    }

    function getRoll() public view returns (string memory) {
        return me.roll;
    }

    function getStruct() public view returns (Card memory) {
        return me;
    }
}
