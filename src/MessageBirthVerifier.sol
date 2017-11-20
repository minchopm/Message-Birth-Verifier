pragma solidity ^0.4.18;

/**
 * A very simple contract which stores message hashes (sha3),
 * when they are created (born) and who sent them.
 * In the contract are kept only messages hashes. There is no messages in plain text here.
 * You can use the contract to verify that someone created a message, on a certain date.
 */
contract MessageBirthVerifier {
    address private creator;

    /**
    * The main data structure of the contract.
    * The key is the sha3 (keccak256) of the message.
    * The value is another map which key is the address of the sender
    * and the value is an array of timestamps - when that message has been
    * sent from that address. If the message is sent only once the array will
    * contain only one timestamp.
    * Those mappings allow us to handle the case when the same message hash
    * is sent more than once including from the same sender.
    */
    mapping(bytes32 => mapping(address => uint[])) public hashAddressTimestamps;

    event NewMessageBorn(address sender, bytes32 messageHash, uint timestamp);

    function SimpleMessageVerifier() public {
        creator = msg.sender;
    }

    function storeMessageHash(bytes32 messageHash) public {
        uint memory timestamp = now;
        hashAddressTimestamps[messageHash][msg.sender].push(timestamp);
        NewMessageBorn(msg.sender, messageHash, timestamp);
    }

    function kill() public { if (msg.sender == creator) selfdestruct(creator); }
}
