// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { Kernel, Keycode } from "src/Kernel.sol";
import { Shelf } from "src/modules/Shelf.sol";

contract WeaponShelf is Shelf {
    constructor(Kernel kernel_) Shelf(kernel_) { }

    function KEYCODE() public pure override returns (Keycode) {
        return Keycode.wrap("WEAPN");
    }
}
