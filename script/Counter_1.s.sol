// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {console} from "forge-std/console.sol";

import {BaseScript} from "./BaseScript.s.sol";
import {Counter} from "../src/Counter.sol";

contract Counter_1Script is BaseScript {
    Counter public counter;


    function run() public broadcast {
        saveAbi("Counter");
        counter = new Counter();
        saveContract("Counter", address(counter));
    }
}