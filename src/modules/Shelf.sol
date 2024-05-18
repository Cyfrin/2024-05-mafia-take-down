// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { Module, Kernel } from "src/Kernel.sol";

abstract contract Shelf is Module {
    mapping(address => uint256) private bank;
    // IERC20 private immutable token;

    constructor(Kernel kernel_) Module(kernel_) { }

    function deposit(address account, uint256 amount) public permissioned {
        bank[account] += amount;
    }

    function withdraw(address account, uint256 amount) public permissioned {
        bank[account] -= amount;
    }

    function getAccountAmount(address account) external view returns (uint256) {
        return bank[account];
    }
}
