pragma solidity >=0.7.0 <0.9.0;


// https://rinkeby.etherscan.io/address/0x617202Cbb85D0891287A9881458edb07762297c0
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./base64.sol";

contract Kudos is ERC721 {
    constructor() ERC721("kudos", "TPK") {

    }
    mapping (address => uint[]) allKudos;
    mapping (uint => Kudo) nfts;
    uint nextTokenID = 0;
    
    function giveKudos(address who, string memory what, string memory comments) public {
        Kudo memory kudo = Kudo(what, msg.sender, comments, nextTokenID, who);
        _mint(who, nextTokenID);
        nfts[nextTokenID] = kudo;
        allKudos[who].push(nextTokenID);
        nextTokenID = nextTokenID + 1; 
    }
    
    function getKudosLength(address who) public view returns(uint) {
        uint[] memory allKudosForWho = allKudos[who];
        return allKudosForWho.length;
    }
    
    function getKudosAtIndex(address who, uint idx) public view returns(string memory, address, string memory) { 
        Kudo memory kudo = nfts[allKudos[who][idx]];
        return (kudo.what, kudo.giver, kudo.comments);
    }

    function getNFTInfo(uint tokenID) public view returns(string memory, address, string memory) {
        Kudo memory kudo = nfts[tokenID];
        return (kudo.what, kudo.giver, kudo.comments);
    }

    function toAsciiString(address x) internal pure returns (string memory) {
    bytes memory s = new bytes(40);
    for (uint i = 0; i < 20; i++) {
        bytes1 b = bytes1(uint8(uint(uint160(x)) / (2**(8*(19 - i)))));
        bytes1 hi = bytes1(uint8(b) / 16);
        bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
        s[2*i] = char(hi);
        s[2*i+1] = char(lo);            
    }
    return string(s);
    }

function char(bytes1 b) internal pure returns (bytes1 c) {
    if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
    else return bytes1(uint8(b) + 0x57);
   }

    function tokenURI(uint tokenID) public view override returns (string memory) {
        Kudo memory kudo = nfts[tokenID];
        
        string[9] memory parts;
        parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';

        parts[1] = toAsciiString(kudo.who);

        parts[2] = '</text><text x="10" y="40" class="base">';

        parts[3] = toAsciiString(kudo.giver) ;

        parts[4] = '</text><text x="10" y="60" class="base">';

        parts[5] = kudo.what;

        parts[6] = '</text><text x="10" y="80" class="base">';

        parts[7] = kudo.comments;

        parts[8] = '</text></svg>';

        string memory image = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]));

        string memory kudoJSON =  Base64.encode(bytes(string(abi.encodePacked('{"image": "data:image/svg+xml;base64,', Base64.encode(bytes(image)), '"}'))));
        string memory output = string(abi.encodePacked('data:application/json;base64,', kudoJSON));

        return output;

    }
    
    
}

struct Kudo {
    string what;
    address giver;
    string comments;
    uint nftTokenID;
    address who;
}


// giving kudos: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2




/*
    Visualize data structure
    allKudos: {
        tanay (Oxwwwiwiwi) : [
        {
            what: "Web 3.0",
            giver: Madhavan (0xwwwowo)
            string: "good job on getting started"
        },
        {
            what: "Web 3.0",
            giver: Krati (0xw2wowo)
            string: "You have come a long way from Microsoft"
        }
        
    ],
    
    hetav (Oxwwwiwiwi) : [
        {
            what: "Web 3.0",
            giver: Madhavan (0xwwwowo)
            string: "good job on getting started"
        },
        {
            what: "Web 3.0",
            giver: Krati (0xw2wowo)
            string: "You have come a long way from Microsoft"
        }
        
    ]
    }
    



    Step I: Define Problem scope
    
    
    Who is giving Kudos?
    Who is getting?
    For what?
    Additional Comments
    
    
    Step II: make a data structure
    
    Queries: 
        1. get all Kudos given by X to Y 
        2. get all kudos received by Y 
        3. get all kudos received for CSS (some tech)
    
    
    
    // How would we do this in MongoDB
    Kudos --> Document 
         {
             who:  (index)
             what:
             comments:
             from: 
         }
    
    
    // Create a dictionary
    
    who: {
        what:
        from:
        comments: 
    }
    
    Address: 0xd9145CCE52D386f254917e481eB44e9943F39138
    
    
    
    
*/
