// @desc means description of the function
// @para means parameters of the function
// @return means return value of the fuction
// @Mod means Access modifier public , private etc
// @header means all the code before the curly braces of the function

// Don't change the the line below its part of the contract
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Storage {
   uint256 id;
   mapping(address => uint256) idOf;
   mapping(address => bool) checkStudent;
   event registered(string _name, string _gender, uint8 age);

   Student[] public list;

   struct Student {
      string name;
      string gender;
      uint8 age;
   }

   /**
    * @para takes the user address
    * @desc Checks if a student already exists with the same address
    */
   modifier studentExists(address _address) {
      require(checkStudent[_address] == false, "Student already exists");
      _;
   }

   /**
    * @Header takes 3 parameters and call the studentExist Modefier with
    * the parameter address of the function caller
    * @desc Create a new student struct and stores inside student list
    */
   function setStudent(
      string memory _name,
      string memory _gender,
      uint8 _age
   ) external studentExists(msg.sender) {
      list.push(Student(_name, _gender, _age));
      idOf[msg.sender] = id;
      checkStudent[msg.sender] = true;
      id++;
      emit registered(_name, _gender, _age);
   }

   function getID() external view returns (uint256) {
      return idOf[msg.sender];
   }

   function getStudent() external view returns (Student memory) {
      return list[idOf[msg.sender]];
   }

   function getStudentName() external view returns (string memory) {
      Student memory student = list[idOf[msg.sender]];
      return student.name;
   }

   function getStudentAge() external view returns (uint256) {
      Student memory student = list[idOf[msg.sender]];
      return student.age;
   }

   function getStudentGender() external view returns (string memory) {
      Student memory student = list[idOf[msg.sender]];
      return student.gender;
   }
}
