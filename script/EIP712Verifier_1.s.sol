pragma solidity ^0.8.26;

import {console} from "forge-std/console.sol";

import {BaseScript} from "./BaseScript.s.sol";
import { EIP712Verifier } from "../src/EIP712Verifier.sol";

contract EIP712Verifier_1Script is BaseScript{
  EIP712Verifier public eip712Verifier;

  function run() public broadcast {
    saveAbi("EIP712Verifier");
    eip712Verifier = new EIP712Verifier();
    console.log("EIP712Verifier deployed to: ", address(eip712Verifier));
    saveContract("EIP712Verifier", address(eip712Verifier));
  }
}
