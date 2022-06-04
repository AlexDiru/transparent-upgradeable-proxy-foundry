// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

contract Greeter1 {
  event Greet(string);

  function greet() public returns (uint) {
    emit Greet("Hello World");
    return 1;
  }
}

contract Greeter2 {
  event Greet(string);

  function greet() public returns (uint) {
    emit Greet("Hi World");
    return 2;
  }
}

contract Greeter3 {
  event Greet(string);

  function greet() public returns (uint, uint) {
    emit Greet("Hai hai");
    return (3, 1000);
  }
}

contract Greeter4 {
  event GreetNumeric(int);
  event GreetName(string);

  struct GreetResponse {
    address caller;
    int value;
  }

  function greet(int _value) public returns (GreetResponse memory) {
    emit GreetNumeric(_value);
    return GreetResponse(msg.sender, _value);
  }

  function greetName(string memory _name) public returns (uint) {
    emit GreetName(string.concat("Hi ", _name));
    return 4;
  } 
}

contract MyGreeter is TransparentUpgradeableProxy {
  constructor(address _logic, address _admin, bytes memory _data) TransparentUpgradeableProxy(_logic, _admin, _data) {
  }
}