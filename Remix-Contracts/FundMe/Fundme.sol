// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "./PriceConverter.sol";

error NotEnoughUSD();
error callFailed();

contract Fundme is Ownable {
   using PriceConverter for uint256;

   uint256 public constant MIN_USD = 50 * 1e18;
   event fundRecieved(uint256 amount, address owner);

   mapping(address => uint256) public addressToAmountFunded;
   address[] public funders;

   function fund() public payable {
      // require(msg.value.getConversionRate() >= MIN_USD  , "Not enough Etheruem");

      if (msg.value.getConversionRate() <= MIN_USD) {
         revert NotEnoughUSD();
      }

      if (addressToAmountFunded[msg.sender] == 0) {
         funders.push(msg.sender);
      }

      addressToAmountFunded[msg.sender] += msg.value;
      emit fundRecieved(msg.value, msg.sender);
   }

   function withdraw() public payable onlyOwner {
      for (
         uint256 funderIndex = 0;
         funderIndex < funders.length;
         funderIndex++
      ) {
         address funder = funders[funderIndex];
         addressToAmountFunded[funder] = 0;
      }
      funders = new address[](0);

      (bool callSuccess, ) = payable(msg.sender).call{
         value: address(this).balance
      }("");

      // require(callSuccess, "Call failed");
      if (callSuccess == false) {
         revert callFailed();
      }
   }

   fallback() external payable {
      fund();
   }

   receive() external payable {
      fund();
   }
}
