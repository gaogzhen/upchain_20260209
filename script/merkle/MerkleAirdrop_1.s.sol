// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {BaseScript} from "../BaseScript.s.sol";
import {MerkleAirdrop} from "../../src/merkle/MerkleAirdrop.sol";
import {MyERC20} from "../../src/MyERC20.sol";

contract MerkleAirdropScript is BaseScript {
    MerkleAirdrop public merkleAirdrop;
    MyERC20 public myERC20;


    function run() public broadcast {
        saveAbi("MerkleAirdrop");
        myERC20 = new MyERC20();
  
        merkleAirdrop = new MerkleAirdrop(address(myERC20));
        saveContract("MerkleAirdrop", address(merkleAirdrop));
    }
}
