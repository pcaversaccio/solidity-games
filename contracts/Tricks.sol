// SPDX-License-Identifier: WTFPL
pragma solidity ^0.8.3;

contract Tricks {
    
    string public trick;
    
    constructor (string memory initTrick) {
        trick=initTrick;
    }
    
    function setTrick(string memory newTrick) public {
        trick=newTrick;
    }
    
    function proposeMe () public view returns(string memory){
        return trick;
    }
}
