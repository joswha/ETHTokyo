pragma soidity ^0.8.13;

import "./iDomainoor.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract Domainoor is iDomainoor, AccessControl {
        
    mapping(bytes32 => DomainObject) public domainStorage;
    mapping(bytes32 => address) public domainOwner;
    uint256 public timelock;
    bytes32 public constant ENDPOINT_ROLE = 0x1337;

    constructor(address _endpoint) {
        timelock = 1 days;
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(ENDPOINT_ROLE, _endpoint);
    }

    // ===================SETTERS===================
    function setDomainOwner(bytes32 memory _domain, address _owner) external override returns (bool) {
        require(hasRole(ENDPOINT_ROLE, msg.sender), "Domainoor: Not an endpoint");
        require(_owner != address(0), "Domainoor: Invalid address");
        // require(_domain.length == 32) ...
        require(domainOwner[_domain] == address(0), "Domainoor: Domain already registered");

        domainOwner[_domain] = _owner;
        return true;
    }

    function updateDomain(bytes32 memory _domain, address[] _contracts, uint256 _state) external override returns (bool) {
        require(domainOwner[_domain] == msg.sender, "Domainoor: Not the domain owner");
        require(_state < 3, "unsuported _state mutex");

        // first call
        if(domainStorage[_domain].creationDate == 0) {
            domainStorage[_domain].creationDate = block.timestamp;
        }

        // update then contracts list if necessary
        for(uint256 i = 0; i < _contracts.length; i++) {
            require(_contracts[i] != address(0));

            domainStorage[_domain].contracts.push(_contracts[i]);
        }

        // update the state if necessary
        domainStorage[_domain].state = _state;
        return true;
    }

    // ===================GETTERS===================
    function getDomainOwner(bytes32 memory _domain) external view override returns (address) {
        return domainOwner[_domain];
    }

}
