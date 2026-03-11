// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {console} from "forge-std/console.sol";
import {Test} from "forge-std/Test.sol";
import {ABIEncode} from "../src/ABIEncode.sol";

contract ABIEncodeTest is Test {
    ABIEncode public abiEncode;
    address public to;
    uint256 public amount;

    function setUp() public {
        abiEncode = new ABIEncode();
        to = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8; // 去掉引号
        amount = 123; // 给一个测试值
    }

    function test_EncodeWithSignature() public view {
        bytes memory encoded = abiEncode.encodeWithSignature(to, amount);
        console.logBytes(encoded); // 使用 logBytes 打印
    }
}
