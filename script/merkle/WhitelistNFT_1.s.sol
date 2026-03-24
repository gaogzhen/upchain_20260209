// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {BaseScript} from "../BaseScript.s.sol";
import {WhitelistNFT} from "../../src/merkle/WhitelistNFT.sol";

contract WhitelistNFTScript is BaseScript {
    WhitelistNFT public whitelistNFT;

    function run() public broadcast {
        saveAbi("WhitelistNFT");
                string memory baseURI = "ipfs://QmPlaceholderForTesting/";
        // string memory initialContractURI = "ipfs://QmPlaceholderForTesting/contract.json";
        whitelistNFT = new WhitelistNFT(baseURI);
        saveContract("WhitelistNFT", address(whitelistNFT));
    }
}
