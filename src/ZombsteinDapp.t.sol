// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;
pragma experimental ABIEncoderV2;

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

    function test_addToPresaleList() public {
        address[2] memory a = [0xf237Cd00e2E32eDCCe79185639ad1FC9EA9A4aA9, 0x71315fbDDdE8D5bc1573C3Df2Af670A6B51ecBeD];
        
        // address[] storage a;

        
        for (uint i = 0; i < a.length; i++) {
            emit log_address(a[i]);
        }
        
        // address[] storage userEntriesTest;
        // a.push(0xf237Cd00e2E32eDCCe79185639ad1FC9EA9A4aA9);
        // a.push(0x71315fbDDdE8D5bc1573C3Df2Af670A6B51ecBeD);


        dapp.addToPresaleList(a);
        assertTrue(dapp.isInPresaleList(a[0]));
        assertTrue(dapp.isInPresaleList(a[1]));
    }
}
