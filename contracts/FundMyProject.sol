//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 50 * 10**18;
    address[] public funders;
    mapping(address => uint256) addressToAmountFounded;
    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate() >= MINIMUM_USD,
            "You need to spend more ETH!"
        );
        funders.push(msg.sender);
        addressToAmountFounded[msg.sender] = msg.value;
    }

    function withdraw() public onlyOwner {
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addressToAmountFounded[funder] = 0;

            funders = address[](0);

            // msg.sender =>> address
            // payable(msg.sender) =>> payable aadress
            //payable(msg.sender) .transfer(address(this).balance);  //Testing noly

            (bool callSuccess, ) = payable(msg.sender).call{
                value: address(this).balance
            }("");
            require(callSuccess, "Call failed");
        }
    }

    modifier onlyOwner() {
        // require(
        //     msg.sender == i_owner,
        //     "Onw is the onlyone allowed to call this!!"
        // );

        if (msg.sender != i_owner) revert NotOwner();
        _; // do the rest of the code
    }

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }
}
