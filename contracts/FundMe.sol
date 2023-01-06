// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./PriceConverter.sol";
//get funds from users
//withdraw funds
//set a minimum funding value in USD

contract FundMe {
    using PriceConverter for uint256;

    constructor () payable{
    }

    uint256 public minimumUsd = 50 * 1e18;

    address [] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    function fund() public payable {
        require(msg.value.getConversionRate() >= minimumUsd, "Didn't send enough!"); //1e18 == 1*10 **18 = 1000000000000000000, this is 1 eth, which is 10^18 wei
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }

    
    function withdraw() public {
        /* inside parentheses = starting index, ending index, step amount */
       for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
           address funder = funders[funderIndex];
           addressToAmountFunded[funder] = 0;
       } 
       //reset the array
       funders = new address[](0);
       //actually withdraw the funds - there are 3 ways to do this: transfer, send and call

       //transfer
       //msg.sender = address; payable(msg.sender) = payable address
       payable(msg.sender).transfer(address(this).balance);

       //send
       bool sendSuccess = payable(msg.sender).send(address(this).balance);
       require(sendSuccess, "send failed");

       //call - this is generally the recommended way to send and receive ETH or blockchain-native tokens
       (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
       require(callSuccess, "Call failed");
    }
    
}