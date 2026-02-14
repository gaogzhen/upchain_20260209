// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";
import {MyERC20} from "../src/MyERC20.sol";

interface ITokenReceiver {
    function tokenReceived(address from, address to, uint256 amount, bytes calldata data) external;
}

contract MockTokenReceiver is ITokenReceiver {
    address public lastFrom;
    address public lastTo;
    uint256 public lastAmount;
    bytes public lastData;
    uint256 public callCount;

    function tokenReceived(address from, address to, uint256 amount, bytes calldata data) external override {
        lastFrom = from;
        lastTo = to;
        lastAmount = amount;
        lastData = data;
        callCount++;
    }
}

contract MyERC20Test is Test {
    MyERC20 public token;

    address public owner;
    address public alice;
    address public bob;

    uint256 constant INITIAL_SUPPLY = 1_000_000 * 1e18;

    function setUp() public {
        owner = address(this);
        alice = makeAddr("alice");
        bob = makeAddr("bob");
        token = new MyERC20();
    }

    function test_Name() public view {
        assertEq(token.name(), "MyERC20");
    }

    function test_Symbol() public view {
        assertEq(token.symbol(), "MET");
    }

    function test_Decimals() public view {
        assertEq(token.decimals(), 18);
    }

    function test_InitialSupply() public view {
        assertEq(token.totalSupply(), INITIAL_SUPPLY);
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY);
    }

    function test_Transfer() public {
        vm.prank(owner);
        bool ok = token.transfer(alice, 100e18);
        assertTrue(ok);
        assertEq(token.balanceOf(alice), 100e18);
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY - 100e18);
    }

    function test_Transfer_InsufficientBalance() public {
        vm.prank(alice);
        vm.expectRevert();
        token.transfer(bob, 1);
    }

    function test_TransferWithCallback_ToEOA() public {
        bytes memory data = "hello";
        vm.prank(owner);
        bool ok = token.transferWithCallback(alice, 200e18, data);
        assertTrue(ok);
        assertEq(token.balanceOf(alice), 200e18);
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY - 200e18);
    }

    function test_TransferWithCallback_ToContract() public {
        MockTokenReceiver receiver = new MockTokenReceiver();
        uint256 amount = 50e18;
        bytes memory data = "callback-data";

        vm.prank(owner);
        bool ok = token.transferWithCallback(address(receiver), amount, data);
        assertTrue(ok);
        assertEq(token.balanceOf(address(receiver)), amount);
        assertEq(receiver.callCount(), 1);
        assertEq(receiver.lastFrom(), owner);
        assertEq(receiver.lastTo(), address(receiver));
        assertEq(receiver.lastAmount(), amount);
        assertEq(receiver.lastData(), data);
    }

    function test_ApproveAndTransferFrom() public {
        vm.prank(owner);
        token.approve(alice, 300e18);

        vm.prank(alice);
        token.transferFrom(owner, bob, 300e18);

        assertEq(token.balanceOf(bob), 300e18);
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY - 300e18);
        assertEq(token.allowance(owner, alice), 0);
    }

    function testFuzz_Transfer(address to, uint256 amount) public {
        vm.assume(to != address(0));
        vm.assume(amount <= INITIAL_SUPPLY);
        vm.prank(owner);
        token.transfer(to, amount);
        assertEq(token.balanceOf(to), amount);
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY - amount);
    }
}
