pragma solidity ^0.8.13;

interface iDomainoor {
    struct DomainObject {
        address owner;
        mapping(address => bool) contracts;
        uint256 creationDate;
    }

    enum Result {
        NOT_REGISTERED,
        REGISTERED_AND_MATCH,
        REGISTERED_AND_NOT_MATCH
    }

    //////
     
    function setDomainOwner(bytes32 _domain, address _owner) external;
    function setTrustedContracts(bytes32 _domain, address[] memory _contracts) external;
    function setTrustedContract(bytes32 _domain, address _contract, bool _trusted) external;
    
    function checkContract(bytes32 _domain, address _to) external view returns (Result);

    function getDomainOwner(bytes32 _domain) external view returns (address);
}
