pragma solidity ^0.8.13;

import "./iDomainoor.sol";
import "lib/openzeppelin-contracts/contracts/access/AccessControl.sol";
import "lib/openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";

contract Domainoor is iDomainoor, AccessControl {
    mapping(bytes32 => DomainObject) public domainObjects;
    uint256 public immutable timelock;
    bytes32 public constant ENDPOINT_ROLE = "0x1337";

    modifier onlyDomainOwner(bytes32 _domain) {
        require(domainObjects[_domain].owner == msg.sender, "Domainoor: Not the domain owner");
        _;
    }

    constructor() {
        timelock = 3 days;
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(ENDPOINT_ROLE, msg.sender);
        _setRoleAdmin(ENDPOINT_ROLE, DEFAULT_ADMIN_ROLE);
    }

    // ===================ENDPOINT===================

    function setDomainOwner(bytes32 _domain, address _owner) external override {
        require(_owner != address(0), "Domainoor: Invalid address");
        DomainObject storage obj = domainObjects[_domain];

        bool isNewDomain = obj.creationDate == 0 || obj.owner == address(0); // || for safety
        bool isEndpoint = hasRole(ENDPOINT_ROLE, msg.sender);
        bool isDomainOwner = obj.owner == msg.sender;

        if (isEndpoint) {
            if (!isNewDomain) 
                // Endpoint can only change domain owner if timelock is not expired
                require(block.timestamp <= obj.creationDate + timelock, "Domainoor: Endpoint's timelock is expired");
            else
                // Endpoints can create new domains at any time.
                // We need to mark that this domain has been created for the first time.
                domainObjects[_domain].creationDate = block.timestamp;

        } else if (isDomainOwner) {
            // Domain owners can change the owner at any time.
            require(!isNewDomain, "Domainoor: No such domain"); // sanity check

        } else {
            revert("Domainoor: Not the domain owner or endpoint");
        }

        domainObjects[_domain].owner = _owner;
    }

    // ===================SETTERS===================

    function setTrustedContracts(bytes32 _domain, address[] memory _contracts) external override onlyDomainOwner(_domain) {
        domainObjects[_domain].contracts = _contracts;
    }

    function setState(bytes32 _domain, uint256 _state) external override onlyDomainOwner(_domain) {
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
