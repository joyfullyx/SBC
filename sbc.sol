pragma solidity >= 0.7.0 < 0.9.0;

contract subieCoin {
    string public symbol = "SBC";
    address public minter;
    mapping (address => uint) public balances;
    uint public Count; //keep log of total number of successful transactions sent
    uint[] public totalMinted; //save amount of minter coins per transaction

    event Sent(address from, address to, uint amount);

    // constructor only runs when we deploy contract
    constructor() {
        minter = msg.sender;
    }

    function mint(address receiver, uint amount) public {
        require(msg.sender == minter, "You do not have permission to mint SBC"); //only owner can mint coins- if not owner, print error string
        balances[receiver] += amount; //adds amount of coins to receiver
        totalMinted.push(amount); //save amount from transaction to totalMinted arr.
    }   

    // error handler
    error insufficientBalance(uint requested, uint available);

    // send any amount of coins to existing address
    function send(address receiver, uint amount) public {
        // require amount to be greater than x = true then run this:
        if(amount > balances[msg.sender]) {
            revert insufficientBalance({
                requested: amount,
                available: balances[msg.sender]
            });
        }
        balances[msg.sender] -= amount; //deduct from acct holder
        balances[receiver] += amount; //add amount to receiver account
        Count += 1; //add to no. of transactions count
        // emit send event
        emit Sent(msg.sender, receiver, amount);
    }

}