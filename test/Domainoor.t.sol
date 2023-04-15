// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Domainoor.sol";
import "../src/iDomainoor.sol";

contract DomainoorTest is Test {
    Domainoor public domainoor;

    bytes32 public constant DOMAIN_TEST = keccak256("uniswap.org");

    function setUp() public {
        domainoor = new Domainoor();
        domainoor.setDomainOwner(DOMAIN_TEST, address(this));
        address[] memory addresses;
        domainoor.setTrustedContracts(DOMAIN_TEST, addresses);
    }

    function test_configure() public {
        setUp();
        address owner = domainoor.getDomainOwner(DOMAIN_TEST);
        assertEq(owner, address(this));
    }

    function test_update_domain() public {
        setUp();
        address[] memory contracts = domainoor.getTrustedContracts(DOMAIN_TEST);
        assertEq(contracts.length, 0); // nothing verified yet

        // now try adding a trusted contract
        address[] memory addresses = new address[](1);
        addresses[0] = address(0x1234);
        domainoor.setTrustedContracts(DOMAIN_TEST, addresses);

        contracts = domainoor.getTrustedContracts(DOMAIN_TEST);
        assertEq(contracts.length, 1);

        // try checking
        require(domainoor.checkContract(DOMAIN_TEST, address(0x1234)) == iDomainoor.Result.REGISTERED_AND_MATCH,
            "contract not verified but should be");
        require(domainoor.checkContract(DOMAIN_TEST, address(0x12345678)) == iDomainoor.Result.REGISTERED_AND_NOT_MATCH,
            "contract verified but should not be");
        require(domainoor.checkContract("0x9999999", address(0x1234)) == iDomainoor.Result.NOT_REGISTERED,
            "contract verified but should not be");
    }
}
