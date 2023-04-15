pragma solidity ^0.8.13;

interface iDomainoor {

    struct DomainObject {
        address[] contracts;
        uint256 state; // 0 - Unregistered, 1 - Registered, 2 - Suspended, 3 - Deleted
        uint256 creationDate;
    }
     
    function setDomainOwner(bytes32 memory _domain, address _owner) external returns (bool);
    function updateDomain(bytes32 memory _domain, DomainObject _domainDetails) external returns (bool);
    function getDomainOwner(bytes32 memory _domain) external view returns (address);
    // function setTimelock(uint256 _timelock) external returns (bool);
    // function getTimelock() external view returns (uint256);
}
