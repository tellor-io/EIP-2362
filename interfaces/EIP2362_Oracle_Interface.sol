pragma solidity >=0.5.3 <0.7.0;

/*
 * @title Price/numeric Pull Oracle Interface
*/

interface Eip2362OracleInterface {
    function valueFor(bytes32 id) external view returns (uint timestamp, int value, uint status);
}