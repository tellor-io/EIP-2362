pragma solidity ^0.5.0;

/*
 * @title Price/numberic Pull Oracle Interface
*/

interface Eip2362OracleInterface {
    function valueFor(bytes32 id) external view returns (uint timestamp, int value);
}