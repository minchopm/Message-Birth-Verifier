pragma solidity ^0.4.19;

/**
 * A very simple contract which stores message hashes (sha3),
 * when they are created (born) and who sent them.
 * In the contract are kept only messages hashes. There is no messages in plain text here.
 * You can use the contract to verify that someone created a message she/he sent to you
 * in plain text, on certain date.
 */
contract MessageBirthVerifier {
    address private creator;

    /**
     * sender - the sender of the message hash.
     * timestamp - timestamp when the contract received the message hash.
     */
    struct MessageEvent {address sender; uint64 timestamp;}

    /**
    * The main data structure of the contract.
    * The key is the sha3 (keccak256) of the message.
    * The value is an array of MessageEvents.
    * This mapping allows us to handle the case when the same message hash
    * is sent more than ones.
    */
    mapping(bytes32 => MessageEvent[]) public messages;

    function SimpleMessageVerifier() {
        creator = msg.sender;
    }

    function storeMessageHash(bytes32 messageHash) public {
        messages[messageHash].push(MessageEvent({sender: msg.sender, timestamp: now}));
    }

    function verify(bytes32 messageHash) {
        return messages[messageHash];
    }

    function kill() { if (msg.sender == creator) suicide(creator); }
}
