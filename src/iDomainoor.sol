pragma solidity ^0.8.13;

interface iDomainoor {

    struct DomainObject {
        address owner;
        address[] contracts;
        uint256 state; // 0 - Default, 1 - Possibly Compromised
        uint256 creationDate;
    }
     
    function setDomainOwner(bytes32 _domain, address _owner) external;
    function setTrustedContracts(bytes32 _domain, address[] memory _contracts) external;
    function setState(bytes32 _domain, uint256 _state) external;

    function getDomainOwner(bytes32 _domain) external view returns (address);
    function getDomain(bytes32 _domain) external view returns (address[] memory, uint256);
    function getTrustedContracts(bytes32 _domain) external view returns (address[] memory);
    function getState(bytes32 _domain) external view returns (uint256);
    
}
