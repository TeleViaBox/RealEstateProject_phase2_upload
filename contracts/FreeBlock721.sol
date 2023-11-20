// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract RealEstateToken is ERC721 {
    uint256 private _nextTokenId = 1;

    constructor() ERC721("RealEstateToken", "RET") {}

    function addProperty(address to) public {
        _safeMint(to, _nextTokenId++);
    }
}
