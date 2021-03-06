// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.3.2 (utils/introspection/ERC165.sol)

pragma solidity ^0.8.0;

import "../interfaces/IERC165.sol";


abstract contract ERC165 is IERC165 {

    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}