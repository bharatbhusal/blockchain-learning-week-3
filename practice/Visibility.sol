// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

contract Visibility{

    //within, outside, derived, others
    function f1() public pure returns(uint){
        return 1;
    }

    //within
    function f2() private pure returns(uint){
        return 2;
    }

    //within, derived
    function f3() internal pure returns(uint){
        return 3;
    }

    //outside, others, derived
    function f4() external pure returns(uint, uint){
        uint v2 = f2(); //internal function within the contract
        return (4, v2);
    }
}
contract TempContract is Visibility{
    function caller() pure  public returns (uint, uint) {
        uint v1 = f1(); //public function in inherited contract.
        uint v3 = f3(); //internal funcion in inherited contract.
        return (v1, v3);
    }
}