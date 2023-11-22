// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

contract GlobalVariables{

    function getter() public view returns( address, uint, uint){
        return (msg.sender, block.chainid, block.timestamp);
    }
}