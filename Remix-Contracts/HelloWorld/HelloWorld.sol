// @desc means description of the function
// @para means parameters of the function
// @return means return value of the fuction

// Don't change the the line below its part of the contract
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract helloWorld {
   string message;

   /**
    * @desc  Sets the initial message to "Hello World"
    */
   constructor() {
      message = "Hello World";
   }

   /**
    * @para takes a simple string input
    * @desc Changes the value of message variable
    */
   function ChangeMessage(string memory _newMessage) public {
      message = _newMessage;
   }

   /**
    * @returns the message"
    */
   function getMessage() public view returns (string memory) {
      return message;
   }
}
