// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract SimpleERC1155 is ERC1155 {
    uint256 public constant PARKING_PASS = 1;
    uint256 public constant NUGGET_COUPON = 2;

    constructor() ERC1155("https://your-metadata-url.com/") {
        // _mint(msg.sender, PARKING_PASS, 10, ""); // mint 10 units to deployer
        // _mint(msg.sender, NUGGET_COUPON, 10, ""); // mint 10 units to deployer
    }

    function claimRewards(address to) public {
        uint256[] memory ids = new uint256[](2);
        uint256[] memory amounts = new uint256[](2);

        ids[0] = PARKING_PASS;
        ids[1] = NUGGET_COUPON;

        amounts[0] = 1; // user get 1 unit
        amounts[1] = 1; // user get 1 unit

        _mintBatch(to, ids, amounts, "");
    }
        
    function getBatchBalance(address owner, uint256[] memory tokenIds) 
        public view returns (uint256[] memory) 
    {
        address[] memory owners = new address[](tokenIds.length);
        for (uint256 i = 0; i < tokenIds.length; i++) {
            owners[i] = owner;
        }
        return balanceOfBatch(owners, tokenIds);
    }
}