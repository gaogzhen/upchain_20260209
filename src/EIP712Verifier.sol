// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";

/**
 * @title 可校验的EIP712
 * @author gaogzhen
 * @notice 可校验的EIP712
 */
contract EIP712Verifier is EIP712 {
    using ECDSA for bytes32;

    struct Send {
        address to;
        uint256 value;
    }

    bytes32 public constant SEND_TYPE_HASH =
        keccak256("Send(address to,uint256 value)");

    constructor() EIP712("EIP712Verifier", "1.0.0") {}

    /**
     * 数据哈希
     * @param send 发送数据结构体
     */
    function hashSend(Send memory send) public view returns (bytes32) {
        return
            _hashTypedDataV4(
                keccak256(abi.encode(SEND_TYPE_HASH, send.to, send.value))
            );
    }

    /**
     * 校验发送数据
     * @param signer 签名者地址
     * @param send 发送数据
     * @param signature 签名
     */
    function verify(
        address signer,
        Send memory send,
        bytes memory signature
    ) public view returns (bool) {
        bytes32 digest = hashSend(send);
        return digest.recover(signature) == signer;
    }

    /**
     * 发送712-带签名
     * @param signer 签名地址
     * @param to 发送地址
     * @param value 值
     * @param signature 签名
     */
    function sendByEIP712Signature(
        address signer,
        address to,
        uint256 value,
        bytes memory signature
    ) public {
        bool suc = verify(signer, Send({to: to, value: value}), signature);
        require(suc, "Invalid signature");
        (bool success, ) = to.call{value: value}("");
        require(success, "Transfer failed");
    }

    /**
      * 获取域分隔符
     */
    function domainSeparator() public view returns (bytes32) {
        return _domainSeparatorV4();
    }
}
