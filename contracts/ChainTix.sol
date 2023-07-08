// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract ChainTix is ERC721 {   

    address public owner;
    uint256 public totalOccasions;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor(string memory _name, string memory _symbol) ERC721(_name,_symbol) {
        owner = msg.sender;
    }

    mapping(uint256 => Occasion) public occasion;

    struct Occasion{
        uint256 id;
        string name;
        uint256 cost;
        uint256 ticket;
        uint256 maxTicket;
        string date;
        string time;
        string location;
    }

    function list(
        string memory _name,
        uint256 _maxTickets,
        uint256 _cost,
        string memory _date,
        string memory _time,
        string memory _location
    ) public onlyOwner {
        totalOccasions++;

        occasion[totalOccasions] = Occasion(
            totalOccasions,
            _name,
            _cost,
            _maxTickets,
            _maxTickets,
            _date,
            _time,
            _location
        );
    }
}
