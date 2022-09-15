//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 50 * 10**18;
    address[] public funders;
    mapping(address => uint256) addressToAmountFounded;

    function fund() public payable {
        require(
            msg.value.getConversionRate() >= MINIMUM_USD,
            "You need to spend more ETH!"
        );
        funders.push(msg.sender);
        addressToAmountFounded[msg.sender] = msg.value;
    }

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }

    // function withdraw() {

    // }
}
