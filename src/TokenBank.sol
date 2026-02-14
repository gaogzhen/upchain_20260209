// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IPermit2} from "@permit2/src/interfaces/IPermit2.sol";
import {ISignatureTransfer} from "@permit2/src/interfaces/ISignatureTransfer.sol";

contract TokenBank {
    IERC20 public immutable token;
    IPermit2 public immutable permit2;

    // 记录每个地址的存款
    mapping(address => uint256) public deposits;
    // 记录存款总数
    uint256 public totalDeposits;

    // 存token事件
    event Deposit(address indexed user, uint256 amount);
    // 取token事件
    event Withdraw(address indexed user, uint256 amount);

    constructor(address _token, address _permit2) {
        token = IERC20(_token);
        permit2 = IPermit2(_permit2);
    }

    modifier greaterThanZero(uint256 _amount) {
        require(_amount > 0, "Amount must be greater than zero");
        _; // 继续执行函数体
    }

    /**
     * 用户存token
     * @param amount 数量
     */
    function deposit(uint256 amount) external greaterThanZero(amount) {
        token.transferFrom(msg.sender, address(this), amount);
        // 更新存款记录
        deposits[msg.sender] += amount;
        totalDeposits += amount;

        emit Deposit(msg.sender, amount);
    }

    /**
     * 授权转账token
     * @param amount 授权数量
     * @param nonce 防止重放攻击的随机数
     * @param deadline 授权截止时间
     * @param signature  授权签名
     */
    function depositWithPermit2(
        uint256 amount,
        uint256 nonce,
        uint256 deadline,
        bytes calldata signature
    ) external greaterThanZero(amount) {
        // 授权token
        ISignatureTransfer.PermitTransferFrom memory permit = ISignatureTransfer
            .PermitTransferFrom({
                permitted: ISignatureTransfer.TokenPermissions({
                    token: address(token),
                    amount: amount
                }),
                nonce: nonce,
                deadline: deadline
            });

        // 接受地址
        ISignatureTransfer.SignatureTransferDetails
            memory transferDetails = ISignatureTransfer
                .SignatureTransferDetails({
                    to: address(this),
                    requestedAmount: permit.permitted.amount
                });

        // 授权和转账
        permit2.permitTransferFrom(
            permit,
            transferDetails,
            msg.sender,
            signature
        );

        // 更新存款记录
        deposits[msg.sender] += permit.permitted.amount;
        totalDeposits += permit.permitted.amount;

        emit Deposit(msg.sender, permit.permitted.amount);
    }

    /**
     * 提取token
     * @param amount 提取数量
     */
    function withdraw(uint256 amount) external greaterThanZero(amount) {
        require(deposits[msg.sender] >= amount, "Insufficient balance!");

        // 更新存款记录
        deposits[msg.sender] -= amount;
        totalDeposits -= amount;

        // 转移token至用户
        token.transfer(msg.sender, amount);

        emit Withdraw(msg.sender, amount);
    }

    /**
     * @notice 查询用户的存款余额
     * @param user 用户地址
     * @return 存款余额
     */
    function balanceOf(address user) external view returns (uint256) {
        return deposits[user];
    }
}
