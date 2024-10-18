// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./PriceConverter.sol";

error FundMe__NotOwner();

/**
 * @title Crowd Funding Project
 * @author Vamshi Rajarapu
 * @notice This contracts collects the funds from various users
 * @dev This implements pricefeeds as our library
 */
contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MIN_USD = 5 * 1e18;

    address[] private s_funders;
    mapping(address => uint256) private s_addressToAmountFunded;

    //immutable and constants save gas
    address private immutable i_owner;
    AggregatorV3Interface private s_priceFeeds;

    //modifier
    modifier OnlyOwner() {
        // require(msg.sender ==  i_owner, "Cannot Withdraw");
        if (msg.sender != i_owner) {
            revert FundMe__NotOwner();
        }
        _;
    }

    constructor(address priceFeedAddress) {
        i_owner = msg.sender;
        s_priceFeeds = AggregatorV3Interface(priceFeedAddress);
    }

    function fund() public payable {
        require(
            PriceConverter.getConversionRate(msg.value, s_priceFeeds) >=
                MIN_USD,
            "Minimum is 5USD"
        );
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public OnlyOwner {
        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }

        //reset the funders
        s_funders = new address[](0);

        //withdraw --> (mostly used call method)

        // //transer = uses 2300 gas and throws error
        // payable(msg.sender).transfer(address(this).balance);

        // //send = uses 2300 gas and returns boolean
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess,"send failed");

        //call = uses all gas and returns boolean
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call Failed");
    }

    function cheaperWithdraw() public OnlyOwner {
        address[] memory funders = s_funders;
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            s_addressToAmountFunded[funders[funderIndex]] = 0;
        }

        s_funders = new address[](0);

        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call Failed");
    }

    //if user try to send funds without calling fund()
    //receive() or fallback()

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    function getPriceFeeds() public view returns (AggregatorV3Interface) {
        return s_priceFeeds;
    }

    function getAddressToAmountFunded(
        address funder
    ) public view returns (uint256) {
        return s_addressToAmountFunded[funder];
    }
}
