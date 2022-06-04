// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "lib/openzeppelin-contracts/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

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

// contract Greeter3 {
//   function greet(string memory _name) public pure returns (string memory) {
//     return string.concat("Hi ", _name);
//   }
// }

// contract Greeter4 {
//   function greet() public pure returns (int) {
//     return 69;
//   }

//   function greetOld(string memory _name) public pure returns (string memory) {
//     return string.concat("Hi ", _name);
//   } 
// }

contract MyGreeter is TransparentUpgradeableProxy {
  constructor(address _logic, address _admin, bytes memory _data) TransparentUpgradeableProxy(_logic, _admin, _data) {
  }
}