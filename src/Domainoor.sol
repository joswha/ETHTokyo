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
            if (!isNewDomain) {
                // Endpoint can only change domain owner if timelock is not expired
                require(block.timestamp <= obj.creationDate + timelock, "Domainoor: Endpoint's timelock is expired");
            } else {
                // Endpoints can create new domains at any time.
                // We need to mark that this domain has been created for the first time.
                obj.creationDate = block.timestamp;
            }
        } else if (isDomainOwner) {
            // Domain owners can change the owner at any time.
            require(!isNewDomain, "Domainoor: No such domain"); // sanity check
        } else {
            revert("Domainoor: Not the domain owner or endpoint");
        }

        obj.owner = _owner;
    }

    // ====================EVAL=====================

    function checkContract(bytes32 _domain, address _to) external view override returns (Result) {
        DomainObject memory obj = domainObjects[_domain];
        if (obj.creationDate == 0) {
            return Result.NOT_REGISTERED;
        }

        for (uint256 i = 0; i < obj.contracts.length; i++) {
            if (obj.contracts[i] == _to) {
                return Result.REGISTERED_AND_MATCH;
            }
        }
        return Result.REGISTERED_AND_NOT_MATCH;
    }

    // ===================SETTERS===================

    function setTrustedContracts(bytes32 _domain, address[] memory _contracts) external override onlyDomainOwner(_domain) {
        domainObjects[_domain].contracts = _contracts;
    }

    // ===================GETTERS===================

    function getDomainOwner(bytes32 _domain) external view override returns (address) {
        return domainObjects[_domain].owner;
    }

    function getTrustedContracts(bytes32 _domain) external view override returns (address[] memory) {
        DomainObject memory obj = domainObjects[_domain];
        require(obj.creationDate != 0, "Domainoor: No such domain");
        return obj.contracts;
    }
}
