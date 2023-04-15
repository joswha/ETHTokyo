pragma solidity ^0.8.13;

import "./iDomainoor.sol";
import "lib/openzeppelin-contracts/contracts/access/AccessControl.sol";
import "lib/openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";

contract Domainoor is iDomainoor, AccessControl {
        
    mapping(bytes32 => DomainObject) public domainObjects;
    mapping(bytes32 => address) public domainOwner;
    uint256 public timelock;
    bytes32 public constant ENDPOINT_ROLE = "0x1337";

    constructor() {
        timelock = 1 days;
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(ENDPOINT_ROLE, msg.sender);
        _setRoleAdmin(ENDPOINT_ROLE, DEFAULT_ADMIN_ROLE);
    }

    // ===================ENDPOINT===================
    function setDomainOwner(bytes32 _domain, address _owner) external override {
        require(hasRole(ENDPOINT_ROLE, msg.sender), "Domainoor: Not an endpoint");
        require(_owner != address(0), "Domainoor: Invalid address");
        // require(_domain.length == 32) ...
        require(domainOwner[_domain] == address(0)
            && domainObjects[_domain].creationDate == 0, "Domainoor: Domain already registered");

        domainOwner[_domain] = _owner;
        domainObjects[_domain].creationDate = block.timestamp;
    }

    // ===================SETTERS===================
    function setTrustedContracts(bytes32 _domain, address[] memory _contracts) external override {
        require(domainOwner[_domain] == msg.sender, "Domainoor: Not the domain owner");
        domainObjects[_domain].contracts = _contracts;
    }

    function setState(bytes32 _domain, uint256 _state) external override {
        require(domainOwner[_domain] == msg.sender, "Domainoor: Not the domain owner");
        require(_state < 3, "Domainoor: Unsuported _state mutex");
        domainObjects[_domain].state = _state;
    }

    // ===================GETTERS===================
    function getDomainOwner(bytes32 _domain) external view override returns (address) {
        return domainOwner[_domain];
    }

    function getTrustedContracts(bytes32 _domain) external view override returns (address[] memory) {
        DomainObject memory obj = domainObjects[_domain];
        require(obj.creationDate != 0, "Domainoor: No such domain");
        return obj.contracts;
    }

    function getState(bytes32 _domain) external view override returns (uint256) {
        DomainObject memory obj = domainObjects[_domain];
        require(obj.creationDate != 0, "Domainoor: No such domain");
        return obj.state;
    }

    function getDomain(bytes32 _domain) external view override returns (address[] memory, uint256) {
        DomainObject memory obj = domainObjects[_domain];
        require(obj.creationDate != 0, "Domainoor: No such domain");
        return (obj.contracts, obj.state);
    }

}
