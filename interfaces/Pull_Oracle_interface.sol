pragma solidity ^0.5.0;

/*
 * @title Price/numberic Pull Oracle Interface
*/

interface Oracle {
function resultFor(bytes32 id) external view returns (uint timestamp, int outcome, int status);
function resultFor(bytes32 id) external view returns (uint timestamp,uint outcome, uint status);
function resultFor(bytes32 id) external view returns (uint timestamp, uint[] outcome, uint[] status);
function resultFor(bytes32 id) external view returns (uint timestamp, bytes32 outcome, uint status);
}