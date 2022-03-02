// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts@4.4.2/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.4.2/access/Ownable.sol";

contract ArtToken is ERC721, Ownable{

    constructor (string memory _name, string memory _symbol)
    ERC721(_name, _symbol){}

    //token counter
    uint256 COUNTER;

    //CUANTO COBRAR
    uint fee = 5 ether;

    //data structure with the properties of the artwork
    struct art {
        string art;
        uint256 id;
        uint256 dna;
        uint8 lvl;
        uint8 rarity;
    }
    //
    art [ ] public art_works;

    //
    event NetWorkArt (address indexed owner, uint256 id, uint256 dna );

    function _createRandomNum(uint256 _mod) internal view returns (uint256) {
        bytes32 hash_randomnumber = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        uint256 randomNum = uint256(hash_randomnumber);
        return randomNum % _mod;
    }
    //nft token creation
    function _createartwork (string memory _name) internal {
        uint8 randRarity = uint8(_createRandomNum(1000));
        uint256 randDNA = _createRandomNum(10**16);
        art memory newArtwork = art(_name, COUNTER, randDNA, 1, randRarity);
        art_works.push(newArtwork);
        _safeMint(msg.sender, COUNTER);
        emit NetWorkArt(msg.sender, COUNTER, randRarity);
        COUNTER++;
  } 
  //actualizar precio
  function updatefree(uint256 _fee) external onlyOwner {
  fee = _fee;     
  }

  //visualizar el balance del smart contract
    function infoSmartcvotract () public view returns (address, uint256){
        address SC_Address = address (this);
        uint SC_money =address(this).balance/10**18;
        return (SC_Address, SC_money);
    }
    //obtener todos los nft tokens que tiene cada usuario
    function getartwortks() public view returns (art [] memory){
        return art_works;
    }

    //obtener tokens nft de un usario
    function getOwnerArtwork(address _owner) public view returns (art [] memory){
        art [] memory result = new art [](balanceOf(_owner));
        uint256 counter_owner =0;
        for (uint256 i = 0; i< art_works.length; i++ ){
            if(ownerOf(i)== _owner) {
                result[counter_owner] = art_works[i];
                counter_owner;
            }
        }
    return result;

    }

    //pago del nft
    function creararterandom (string memory _name) public payable{
       require (msg.value >= fee); 
       _createartwork(_name);
    }
    //extraccion de ether deL smart contrtact
    function withdraw() external payable onlyOwner{
        address payable _owner = payable(owner());
        _owner.transfer(address(this).balance);

    }
    function levelup(uint256 _artID) public {
        require(ownerOf(_artID) == msg.sender);
        art storage arte = art_works[_artID];
        arte.lvl++;
    }
}
