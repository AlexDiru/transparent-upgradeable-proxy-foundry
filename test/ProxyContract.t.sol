// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "src/ProxyContract.sol";
import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import "lib/solidity-bytes-utils/contracts/BytesLib.sol";

contract MyGreeterTest is Test {
  event Greet(string);

    MyGreeter myGreeter;
    address admin;

    function setUp() public {
      admin = address(this);

      Greeter1 greeter1 = new Greeter1();

      myGreeter = new MyGreeter(address(greeter1), admin, abi.encode());
    }

    function adminCannotFallback() public {
      (bool sent, bytes memory data) = address(myGreeter).call{value: 0}(abi.encodeWithSignature("greet()"));
    }

    function testGreeter1Impl() public {
        vm.prank(address(1));
        vm.expectEmit(false, false, false, true);
        emit Greet("Hello World");
        (bool sent, bytes memory data) = address(myGreeter).call{value: 0}(abi.encodeWithSignature("greet()"));
        
        assertTrue(sent);
        uint res = BytesLib.toUint256(data, 0);
        assertEq(res, 1);
    }

    function testGreeter2Impl() public {
        myGreeter.upgradeTo(address(new Greeter2()));

        vm.prank(address(1));
        vm.expectEmit(false, false, false, true);
        emit Greet("Hi World");
        (bool sent, bytes memory data) = address(myGreeter).call{value: 0}(abi.encodeWithSignature("greet()"));
        
        assertTrue(sent);
        uint res = BytesLib.toUint256(data, 0);
        assertEq(res, 2);
    }
}