// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19;

import { MiniMeToken } from "@vacp2p/minime/contracts/MiniMeToken.sol";

contract SNTV2 is MiniMeToken {
    constructor(
        string memory _tokenName,
        uint8 _decimalUnits,
        string memory _tokenSymbol,
        bool _transferable
    )
        MiniMeToken(MiniMeToken(payable(address(0))), 0, _tokenName, _decimalUnits, _tokenSymbol, _transferable)
    { }
}
