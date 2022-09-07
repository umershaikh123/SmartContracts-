// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract GatheringFunds is Ownable {
    event Donated(uint256 amount, address user);
    event withdrawn(uint256 amount, address owner);

    uint256 private maxFund;
    uint256 private currentFund;
    uint256 timePeriod;
    address[] funders;
    mapping(address => uint256) AmountFunded;

    function createGoal(uint256 _target) external {
        maxFund = _target;
    }

    function getMaxFund() public view returns (uint256) {
        return maxFund;
    }

    function getCurrentFund() public view returns (uint256) {
        return currentFund;
    }

    function Donate() external payable {
        require(msg.value >= 0, "Can't send zero fund");
        require(maxFund >= currentFund + msg.value, "Max amount Reached");

        AmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
        currentFund += msg.value;

        emit Donated(msg.value, msg.sender);
    }

    function withdraw() public payable onlyOwner {
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");

        require(callSuccess, "Call failed");
        emit withdrawn(currentFund, msg.sender);
    }

    // fallback() external payable {
    //    Donate();
    // }

    // receive() external payable {
    //    Donate();
    // }
}

contract fundsFactory is Ownable {
    uint256 instance;
    event NewContract(string);
    GatheringFunds[] public ArrayOfSmartContract;

    function CreateNewContract() external onlyOwner {
        GatheringFunds smartContract = new GatheringFunds();
        ArrayOfSmartContract.push(smartContract);
        instance++;
        emit NewContract("New Smart Contract created");
    }
}
