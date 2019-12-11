pragma solidity ^0.5.0;

/*
 * @title Price/numberic Pull Oracle mapping contract
*/

contract OracleIDDescriptions {

/*Variables*/
mapping(bytes32 =>string) bytesToString;
mapping(string=>bytes32) stringToBytes;

//should status enum be defined here too?

/*Events*/
event NewIDAdded(bytes32 _id, string _description);

/*Functions*/
//whitelist function for adding or open?

function defineBytes32ID (string memory _description, uint _granularity) 
external 
returns(bytes32 _id)
{
	_id = keccak256(abi.encodePacked(_descrption, _granularity));
    //_id = keccak256(_description)];
    bytesToString[_id] = _description;
    stringToBytes[_description]= _id;
    emit NewIDAdded(_id, _description);
    return(_id);
}


function whatIsIdDescription (bytes32 _id) 
public
returns(string memory _description) 
{
   _description = bytesToString[_id];
   return(_descripion);
}


function whatIsStringID (string memory _description) 
public 
returns(bytes32 _id)
{
    _id = stringToBytes[_description];
    return(_descripion);
}

}