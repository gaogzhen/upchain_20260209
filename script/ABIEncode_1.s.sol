// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {BaseScript} from "./BaseScript.s.sol";
import {ABIEncode} from "../src/ABIEncode.sol";

contract ABIEncodeScript is BaseScript {
    ABIEncode public abiEncode;

    function run() public broadcast {
        saveAbi("ABIEncode");
        abiEncode = new ABIEncode();
        saveContract("ABIEncode", address(abiEncode));
    }
}
