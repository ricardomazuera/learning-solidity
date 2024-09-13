// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {SimpleStorage} from "./simpleStorage.sol";

/*
This contract inherits from SimpleStorage 
and therefore has all the functionality of that contract.
*/
contract AddFiveStorage is SimpleStorage{
    
    /* 
    We want that stora plus 5 to all numbers
    for that we going to use overrides and we need know two keywords:
        1. virtual
        2. override
    */

    function store(uint256 _newNumber) public override {
        myFavoriteNumber = _newNumber *2;
    }

}