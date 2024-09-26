// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

/* 
    Within this contract we need:
    - Get funds from users
    - Withdraw funds
    - Set a minimum funding value in USD
*/
contract FundMe{
    // This said that we going to use PriceConverter as uint256
    using PriceConverter for uint256;

    uint256 public constant MINIMUN_USD = 5e18; // 5 is the value and e18 are the zeros

    // We want see have the address of funders

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    address public immutable i_owner;

    constructor(){
        i_owner = msg.sender;
    }

    /*
        This function allos users to send $
        Have a minimum $ to send $5
        Allow to send ETH to this contract regardless of the currency of address
    */
    function fund() public payable {
        // Require is a checker
        // msg.value is a internal variable of solidity to describe EHT value
        // require(msg.value > 1e18, "didn't send enough ETH"); // 1e18 = 1 ETH = 1000000000000000000 = 1 * 10 ** 18
     

        /*
            What is a revert?
            Undo any action that have been done, and send the remaining gas back 
        */

        
        require(msg.value.getCoversionRate() >= MINIMUN_USD,"didn't send enough ETH");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    /*
        withdraw permits retire the founds into the contract
    */
    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);

        /*
            We have three forms to retire the founds:
            1. Transfer: More superficial and easy
            2. Send
            3. Call
        */

        /*
            TRANSFER
            If fail, returns an error and revert the transaction

            msg.sender = address
            payable(msg.sender) = payable address
        */
        // payable(msg.sender).transfer(address(this).balance);

        /*
            SEND
            Return bool when finish the operation
        *//*
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require(sendSuccess, "Send failed");

        /*
            CALL
            We can use it to call any function in all Ethereum
        */
        (
            bool callSuccess,
            /* bytes memory dataReturned*/ 
        )=payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Send failed");
    }

    modifier onlyOwner() {
        // require(msg.sender == i_owner, "Sender is not owner!");
        
        // We can use custom errors
        if (msg.sender != i_owner) {revert NotOwner();}
        _;
    }

    
    /*
        What happens if someone sends this contract ETH without calling the fund function       
        We add fallback & receive special functions, in case
        any need send us money instead a calling the fund() function
    */

    receive() external payable {
        fund();
     }

    fallback() external payable { 
        fund();
    }

}