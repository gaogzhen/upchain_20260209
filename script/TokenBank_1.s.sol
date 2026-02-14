// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {console} from "forge-std/console.sol";

import {BaseScript} from "./BaseScript.s.sol";
import {TokenBank} from "../src/TokenBank.sol";

contract TokenBank_1Script is BaseScript {
    TokenBank public tokenBank;


    function run() public broadcast {
        saveAbi("TokenBank");
        tokenBank = new TokenBank(address(0x1111), address(0x1111));
        console.log("TokenBank deployed to:", address(tokenBank));
        saveContract("TokenBank", address(tokenBank));
    }
}