// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

contract BalanceContract{

    address payable user = payable(0x0A098Eda01Ce92ff4A4CCb7A4fFFb5A43EBC70DC);

    function payEth() public payable {

    }

    function getEthBalance() public view returns(uint){
        return address(this).balance;
    }

    function sendEth() public {
        user.transfer(2 ether);
    }
}