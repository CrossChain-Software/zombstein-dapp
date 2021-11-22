// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import "./contracts/ERC721.sol";
import "./utils/Ownable.sol";

contract ZombsteinDapp is ERC721, Ownable{
    uint256 public constant team_amount = 8;
    uint256 public constant internal_withold_amount = 80;
    uint256 public constant pre_sale_amount = 2200;
    uint256 public constant public_sale_amount = 6600;
    uint256 public constant max_amount = team_amount + internal_withold_amount + pre_sale_amount + public_sale_amount;
    uint256 public constant price = 0.08 ether;
    uint256 public constant max_per_tx = 5;

    mapping(address => bool) public presalerList;
    mapping(address => uint256) public presalerListPurchases;
    mapping(string => bool) private _usedNonces;

    string private _contractURI;
    string private _tokenBaseURI = "";
    // address private _signerAddress = 0x0000000000000000000000000000000000000000;

    uint256 public giftedAmount;
    uint256 public presaleAmountMinted;
    uint256 public publicAmountMinted;
    uint256 public presalePurchaseLimit = 5;
    bool public isPresaleLive;
    bool public isSaleLive;
    bool public isLocked;

    constructor() ERC721("Zombstein", "ZOMB") {}

    modifier notLocked {
        require(!isLocked, "Contract metadata methods are locked");
        _;
    }

    function addToPresaleList(address[] calldata userEntries) external onlyOwner {
        for(uint256 i = 0; i < userEntries.length; i++) {
            address userEntry = userEntries[i];
            require(userEntry != address(0), "null address");
            require(!presalerList[userEntry], "duplicate entry");
            
            // add to mapping, makes searching based on address easier
            presalerList[userEntry] = true;
        }
    }

    function removeFromPresaleList(address[] calldata userEntries) external onlyOwner {
        for (uint256 i = 0; i < userEntries.length; i++) {
            address userEntry = userEntries[i];
            require(userEntry != address(0), "null address");

            // remove from mapping, makes searching based on address easier
            presalerList[userEntry] = false;
        }
    }


}
