// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

contract EnumsDemo{
    enum user{
        allowed,
        not_allowed,
        waiting,
        blacklisted
    }

    user public bharat = user.waiting;

    function identify_user() public view returns(string memory){
        if (bharat == user.allowed){
            return "User allowed";
        } else if (bharat == user.waiting){
            return "User waiting";
        } else if (bharat == user.blacklisted){
            return "User blacklisted";
        } else {
            return "User not allowed";
        }
    }
}