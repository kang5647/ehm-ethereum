// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract HASS is AccessControl {
    using Counters for Counters.Counter;

    bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");
    bytes32 public constant SCHOLAR_ROLE = keccak256("SCHOLAR_ROLE");
    Counters.Counter private _editIds;

    struct Edit {
        uint256 editId;
        uint256 docId;
        string hash; // Hash of the edit content stored in IPFS
        uint256 startChar;
        uint256 endChar;
        uint256 timestamp; // Timestamp when the edit was added
    }

    // Mapping from document ID to list of edits
    mapping(uint256 => Edit[]) private _documentEdits;

    // Array to keep track of all scholars
    address[] private scholars;

    // Events
    event OwnerAdded(address indexed user);
    event OwnerRemoved(address indexed user);
    event ScholarAdded(address indexed user, bool status);
    event ScholarRemoved(address indexed user, bool status);
    event EditAdded(uint256 indexed editId, uint256 docId, string hash, uint256 startChar, uint256 endChar, uint256 timestamp);

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(OWNER_ROLE, msg.sender);
        _grantRole(SCHOLAR_ROLE, msg.sender);
        scholars.push(msg.sender);
    }

    /// @dev Adds a new owner
    /// @param newOwner Address of the new owner
    function addOwner(address newOwner) external onlyRole(OWNER_ROLE) {
        grantRole(OWNER_ROLE, newOwner);
        if (!hasRole(SCHOLAR_ROLE, newOwner)) {
            grantRole(SCHOLAR_ROLE, newOwner);
            scholars.push(newOwner);
            emit ScholarAdded(newOwner, true);
        }
        emit OwnerAdded(newOwner);
    }

    /// @dev Removes an owner
    /// @param owner Address of the owner to remove
    function removeOwner(address owner) external onlyRole(OWNER_ROLE) {
        require(owner != msg.sender, "Cannot remove self as owner");
        revokeRole(OWNER_ROLE, owner);
        emit OwnerRemoved(owner);
        // Note: We don't remove the SCHOLAR_ROLE or from the scholars array
        // This allows former owners to retain scholar privileges if desired
    }

    /// @dev Grants SCHOLAR_ROLE to a user
    /// @param user Address of the user to grant SCHOLAR_ROLE
    function addScholar(address user) external onlyRole(OWNER_ROLE) {
        grantRole(SCHOLAR_ROLE, user);
        scholars.push(user);
        emit ScholarAdded(user, true);
    }

    /// @dev Revokes SCHOLAR_ROLE from a user
    /// @param user Address of the user to revoke SCHOLAR_ROLE
    function removeScholar(address user) external onlyRole(OWNER_ROLE) {
        require(!hasRole(OWNER_ROLE, user), "Cannot remove SCHOLAR_ROLE from an OWNER");
        revokeRole(SCHOLAR_ROLE, user);
        for (uint i = 0; i < scholars.length; i++) {
            if (scholars[i] == user) {
                scholars[i] = scholars[scholars.length - 1];
                scholars.pop();
                break;
            }
        }
        emit ScholarRemoved(user, false);
    }

    /// @dev Retrieves the list of all scholars
    /// @return Array of scholar addresses
    function getScholars() external view returns (address[] memory) {
        return scholars;
    }

    /// @dev Adds a new edit to a document
    /// @param docId Document ID to add the edit to
    /// @param editHash Hash of the edit content
    /// @param startChar Starting character index of the edit
    /// @param endChar Ending character index
    function addEdit(uint256 docId, string memory editHash, uint256 startChar, uint256 endChar) external onlyRole(SCHOLAR_ROLE) {
        _editIds.increment();
        uint256 newEditId = _editIds.current();
        Edit memory newEdit = Edit(newEditId, docId, editHash, startChar, endChar, block.timestamp);
        _documentEdits[docId].push(newEdit);
        emit EditAdded(newEditId, docId, editHash, startChar, endChar, block.timestamp);
    }

    /// @dev Retrieves all edits associated with a document
    /// @param docId Document ID to retrieve edits for
    /// @return array of edits
    function getDocumentEdits(uint256 docId) external view returns (Edit[] memory) {
        return _documentEdits[docId];
    }

    /// @dev Retrieves a specific edit by edit ID and document ID
    /// @param docId Document ID of the edit
    /// @param editId Edit ID to retrieve details for
    /// @return edit details
    function viewEdit(uint256 docId, uint256 editId) external view returns (Edit memory) {
        Edit[] memory edits = _documentEdits[docId];
        for (uint i = 0; i < edits.length; i++) {
            if (edits[i].editId == editId) {
                return edits[i];
            }
        }
        revert("Edit not found.");
    }
}