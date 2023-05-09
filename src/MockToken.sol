// SPDX-License-Identifier: MIT


pragma solidity 0.8.17;


import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract smartPulse is ERC20 {
    event earnStage(
        address indexed User, 
        uint256 indexed level, 
        uint256 indexed reward
    );

    struct User{
        uint256 level;
        uint256 lastEarned;
    }
 
    address owner;
    mapping(address => User) lvl;
    mapping(address => uint256) amountMinted;

    constructor() ERC20("smartCoin", "SMC"){
        
        owner = msg.sender;

    }




    function mint(uint amount) public { 

        _mint(owner, amount * 10**decimals());
        amountMinted[msg.sender] = amount;
    }

    function earn() public {
        User storage user = lvl[msg.sender];
        uint256 stage = user.level += 1;
        require(user.lastEarned < stage, "Level reward already earned!!!");
        //user.lastEarned +=1;
        _mint(msg.sender, stage * 10**decimals());
        user.level = stage;
        user.lastEarned = stage;
        amountMinted[msg.sender] = stage;

        emit earnStage(msg.sender, user.level, user.lastEarned);
    }


    function buyTOKEN(uint256 token) payable public {
        uint256 price = 5;
        require(msg.sender != address(0), "Zero Address!");
        require( msg.value >= price * token , "Insufficient balance!!!");
    
        _transfer(owner, msg.sender, token * 1e18);
    }
    
}