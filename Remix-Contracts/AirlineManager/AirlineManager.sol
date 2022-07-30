// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract AirlineTicketManager is Ownable {
   uint256 FirstClassPrice;
   uint256 BusinessClassPrice;
   uint256 EconomyClassPrice;

   mapping(address => uint32) TicketNo;
   mapping(address => bool) whitelist;

   mapping(address => User) Userof;
   mapping(address => bool) UserEntry;
   mapping(address => Ticket) UserTicket;

   event TicketBooked(string class, bool TicketBooked, address addr);
   event UserRegistered(
      string _name,
      string _destination,
      uint256 _passportId,
      address addr
   );
   event AddedToWhitelist(address indexed account);
   event RemovedFromWhitelist(address indexed account);

   string[3] public Airclass = ["FirstClass", "BusinessClass", "EconomyClass"];

   struct User {
      string name;
      string destination;
      uint256 passportId;
   }

   struct Ticket {
      string class;
      bool TicketBooked;
   }

   constructor() {
      FirstClassPrice = 0.01 ether;
      BusinessClassPrice = 0.007 ether;
      EconomyClassPrice = 0.005 ether;
   }

   modifier CheckUser() {
      require(UserEntry[msg.sender] == false);
      _;
   }

   modifier OnlyOneTicket(address user) {
      require(TicketNo[user] < 1);
      _;
   }

   modifier onlyWhitelisted() {
      require(isWhitelisted(msg.sender));
      _;
   }

   //Task 1 : Registering a User
   function RegisterUser(
      string memory _name,
      string memory _destination,
      uint256 _passportId
   ) external CheckUser {
      Userof[msg.sender] = User(_name, _destination, _passportId);
      UserEntry[msg.sender] = true;
      emit UserRegistered(_name, _destination, _passportId, msg.sender);
   }

   function _TicketBooked(address addr, uint32 index) internal {
      UserTicket[addr] = Ticket(Airclass[index], true);
      emit TicketBooked(Airclass[index], true, addr);
      TicketNo[addr]++;
   }

   //Task 2,3,4 : User select any one class and buys its ticket
   function BookFirstClassTicket()
      external
      payable
      onlyWhitelisted
      OnlyOneTicket(msg.sender)
   {
      require(
         msg.value >= FirstClassPrice,
         "Not Enough Ether for First Class Ticket"
      );
      address payable extra = payable(msg.sender);
      extra.transfer(msg.value - FirstClassPrice);
      _TicketBooked(msg.sender, 0);
   }

   function BookBusinessClassTicket()
      external
      payable
      onlyWhitelisted
      OnlyOneTicket(msg.sender)
   {
      require(
         msg.value >= BusinessClassPrice,
         "Not Enough Ether for Business Class Ticket"
      );
      address payable extra = payable(msg.sender);
      extra.transfer(msg.value - BusinessClassPrice);
      _TicketBooked(msg.sender, 1);
   }

   function BookEconomyClassTicket()
      external
      payable
      onlyWhitelisted
      OnlyOneTicket(msg.sender)
   {
      require(
         msg.value >= EconomyClassPrice,
         "Not Enough Ether for Economy Ticket"
      );
      address payable extra = payable(msg.sender);
      extra.transfer(msg.value - EconomyClassPrice);
      _TicketBooked(msg.sender, 2);
   }

   function setFirstClassPrice(uint256 newPrice)
      external
      onlyOwner
      returns (uint256)
   {
      FirstClassPrice = newPrice;
      return FirstClassPrice;
   }

   function setBusinesstClassPrice(uint256 newPrice)
      external
      onlyOwner
      returns (uint256)
   {
      BusinessClassPrice = newPrice;
      return BusinessClassPrice;
   }

   function setEconomyClassPrice(uint256 newPrice)
      external
      onlyOwner
      returns (uint256)
   {
      EconomyClassPrice = newPrice;
      return EconomyClassPrice;
   }

   function getUser() public view returns (User memory) {
      return Userof[msg.sender];
   }

   function getTicket() public view returns (Ticket memory) {
      return UserTicket[msg.sender];
   }

   //Task 5 Allowed list of Addresses
   function add(address _address) public onlyOwner {
      whitelist[_address] = true;
      emit AddedToWhitelist(_address);
   }

   function remove(address _address) public onlyOwner {
      whitelist[_address] = false;
      emit RemovedFromWhitelist(_address);
   }

   function isWhitelisted(address _address) public view returns (bool) {
      return whitelist[_address];
   }
} // contract

//Task 6 Factory pattern
contract AirlineTicketManagerFactory is Ownable {
   uint256 instance;
   AirlineTicketManager[] public arrayOfTicketManager;
   event AirlineCreated(string nameOfAirline);

   function CreateNewManager(string memory nameOfAirline) external onlyOwner {
      AirlineTicketManager ALM = new AirlineTicketManager();
      arrayOfTicketManager.push(ALM);
      emit AirlineCreated(nameOfAirline);
      instance++;
   }
}
