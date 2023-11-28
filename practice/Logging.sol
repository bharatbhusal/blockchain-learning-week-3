// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

contract Logging {
    event eventDemo(uint roll, uint age, string name, string indexed last);

    function callEmmit() public {
        emit eventDemo(45, 33, "bharat", "bhusal");
    }
}
