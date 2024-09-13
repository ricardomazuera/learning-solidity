// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {SimpleStorage} from "./simpleStorage.sol";

contract StorageFactory{

    // This create a new simpleStorage and rewrite the contract in simpleStorage variable
    // SimpleStorage public simpleStorage;

    // But as we want deploy a lot of contracts, we need create a list of simpleStorage;
    SimpleStorage[] public listOfSimpleStorageContracts;

    function createSimpleStorageContract() public {
        /*
        This is a single variable
        simpleStorage = new SimpleStorage();
        */

        // This is a list of contracts
        SimpleStorage newSimpleStorageContract = new SimpleStorage();
        listOfSimpleStorageContracts.push(newSimpleStorageContract);
    }

    // Now we going to call each function in SimpleStorage
    function sfStore(uint256 _simpleStorageIdx, uint256 _newSimpleStorageNumber) public {
        /*
        To interact with other contract, we need two things:
            - Address
            - ABI - Application Binary Interface (tecnically a lie, you just need the function selector)
        */

        listOfSimpleStorageContracts[_simpleStorageIdx].store(_newSimpleStorageNumber);    
    }

    // This function return the _newSimpleStorageNumber
    function sfGet(uint256 _simpleStorageIdx) public view returns(uint256) {
        return listOfSimpleStorageContracts[_simpleStorageIdx].retrieve();
    }

}