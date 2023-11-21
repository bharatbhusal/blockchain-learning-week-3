// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;



contract MappingContract {

    enum branch{
        CSE,
        CS,
        AI_ML,
        IOT
    }

    enum rollInitialsType{
        HU21,
        HU22,
        VU21,
        VU22
    }

    struct User {
        uint class_roll;
        string name;
        branch course_branch;
        rollInitialsType rollInitials;
    }

    mapping(uint => User) public roll_to_name;
    User public student;

    constructor(uint roll, string memory name) {
        student.class_roll = roll;
        student.name = name;
        student.course_branch = branch.CS;
        student.rollInitials = rollInitialsType.HU21;
    }
}
