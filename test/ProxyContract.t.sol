// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "src/ProxyContract.sol";
import "forge-std/Test.sol";
import "forge-std/Vm.sol";

contract MyGreeterTest is Test {
  event Greet(string);
  event GreetNumeric(int);
  event GreetName(string);

  MyGreeter myGreeter;

  struct GreetResponse {
    address caller;
    int value;
  }

  function setUp() public {
    myGreeter = new MyGreeter(address(new Greeter1()), address(this), abi.encode());
  }

  function testAdminCannotFallback() public {
    (bool sent, /*bytes memory data*/) = address(myGreeter).call{value: 0}(abi.encodeWithSignature("greet()"));
    assertFalse(sent);
  }

  function testNonAdminCannotUpgrade() public {
    address newImpl = address(new Greeter2());

    vm.prank(address(1));
    vm.expectRevert();
    myGreeter.upgradeTo(newImpl);
  }

  function testGreeter1Impl() public {
    vm.prank(address(1));
    vm.expectEmit(false, false, false, true);
    emit Greet("Hello World");
    (bool sent, bytes memory data) = address(myGreeter).call{value: 0}(abi.encodeWithSignature("greet()"));
    
    assertTrue(sent);

    uint result = abi.decode(data, (uint));
    assertEq(result, 1);
  }

  function testGreeter2Impl() public {
    myGreeter.upgradeTo(address(new Greeter2()));

    vm.prank(address(1));
    vm.expectEmit(false, false, false, true);
    emit Greet("Hi World");
    (bool sent, bytes memory data) = address(myGreeter).call{value: 0}(abi.encodeWithSignature("greet()"));
    
    assertTrue(sent);

    uint result = abi.decode(data, (uint));
    assertEq(result, 2);
  }

  function testGreeter3Impl() public {
    myGreeter.upgradeTo(address(new Greeter3()));

    vm.prank(address(1));
    vm.expectEmit(false, false, false, true);
    emit Greet("Hai hai");
    (bool sent, bytes memory data) = address(myGreeter).call{value: 0}(abi.encodeWithSignature("greet()"));
    
    assertTrue(sent);

    (uint a, uint b) = abi.decode(data, (uint, uint));
    assertEq(a, 3);
    assertEq(b, 1000);
  }

  function testGreeter4Impl_GreetNum() public {
    myGreeter.upgradeTo(address(new Greeter4()));

    vm.prank(address(1));
    vm.expectEmit(false, false, false, true);
    emit GreetNumeric(69);
    (bool sent, bytes memory data) = address(myGreeter).call{value: 0}(abi.encodeWithSignature("greet(int256)", 69));

    assertTrue(sent);

    GreetResponse memory greetResponse = abi.decode(data, (GreetResponse));
    assertEq(greetResponse.caller, address(1));
    assertEq(greetResponse.value, 69);
  }

  function testGreeter4Impl_GreetName() public {
    myGreeter.upgradeTo(address(new Greeter4()));
    
    vm.prank(address(1));
    vm.expectEmit(false, false, false, true);
    emit GreetName("Hi Alex");
    (bool sent, bytes memory data) = address(myGreeter).call{value: 0}(abi.encodeWithSignature("greetName(string)", "Alex"));

    assertTrue(sent);

    uint result = abi.decode(data, (uint));
    assertEq(result, 4);
  }
}