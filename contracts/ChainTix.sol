// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract ChainTix is ERC721 {   
    using SafeMath for uint256;

    address public owner;
    uint256 public totalSupply;
    uint256 public totalOccasions;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {
        owner = msg.sender;
    }

    mapping(uint256 => Occasion) public occasion;
    mapping(uint256 => mapping(address => bool)) public hasBought;
    mapping(uint256 => mapping(uint256 => address)) public seatTaken;
    mapping(uint256 => uint256[]) public seatsTaken;

    struct Occasion {
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

    function getOccasion(uint256 _id) public view returns (Occasion memory) {
        return occasion[_id];
    }

    function mint(uint256 _id, uint256 _seat) public payable{

        occasion[_id].ticket -=1; // <-- update Ticket counter

        hasBought[_id] [msg.sender] = true; // <-- Update buying status

        seatTaken[_id][_seat] = msg.sender; // <-- Assign the seat

        seatsTaken[_id].push(_seat); // <-- Update seats that are currently taken

        totalSupply++;
        _safeMint(msg.sender,totalSupply);
    }
}
