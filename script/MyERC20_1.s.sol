// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {console} from "forge-std/console.sol";

import {BaseScript} from "./BaseScript.s.sol";
import {MyERC20} from "../src/MyERC20.sol";

contract MyERC20_1Script is BaseScript {
    MyERC20 public myERC20;


    function run() public broadcast {
        saveAbi("MyERC20");
        myERC20 = new MyERC20();
        console.log("MyERC20 deployed to:", address(myERC20));
        saveContract("MyERC20", address(myERC20));
    }
}