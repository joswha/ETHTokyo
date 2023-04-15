pragma solidity ^0.8.13;

interface iDomainoor {

    struct DomainObject {
        address owner;
        address[] contracts;
        uint256 creationDate;
    }

    enum Result {
        NOT_REGISTERED,
        REGISTERED_AND_MATCH,
        REGISTERED_AND_NOT_MATCH
    }

     
    function setDomainOwner(bytes32 _domain, address _owner) external;
    function setTrustedContracts(bytes32 _domain, address[] memory _contracts) external;

    function getDomainOwner(bytes32 _domain) external view returns (address);
    function getTrustedContracts(bytes32 _domain) external view returns (address[] memory);
    
    function checkContract(bytes32 _domain, address _to) external view returns (Result);
}
