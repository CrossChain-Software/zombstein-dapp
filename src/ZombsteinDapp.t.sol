// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import "ds-test/test.sol";

import "./ZombsteinDapp.sol";

contract ZombsteinDappTest is DSTest {
    ZombsteinDapp dapp;

    function setUp() public {
        dapp = new ZombsteinDapp();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
