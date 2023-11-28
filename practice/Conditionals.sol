// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

contract Conditionals {
    function demo(uint8 day_number) public pure returns (string memory) {
        if (day_number == 0) {
            return "Sunday";
        } else if (day_number == 1) {
            return "Monday";
        } else if (day_number == 2) {
            return "Tuesday";
        } else if (day_number == 3) {
            return "Wednesday";
        } else if (day_number == 4) {
            return "Thrusday";
        } else if (day_number == 5) {
            return "Friday";
        } else if (day_number == 6) {
            return "Saturday";
        } else {
            return "Invalid Day number!!";
        }
    }
}
