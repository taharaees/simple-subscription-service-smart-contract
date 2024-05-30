pragma solidity ^0.8.0;

contract NetflixSubscription {
    address public owner;
    uint256 public subscriptionFee;
    mapping(address => bool) public subscribers;

    event SubscriptionRenewed(address indexed subscriber, uint256 timestamp);

    constructor(uint256 _subscriptionFee) {
        owner = msg.sender;
        subscriptionFee = _subscriptionFee;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function subscribe() external payable {
        require(msg.value == subscriptionFee, "Incorrect subscription fee");
        require(!subscribers[msg.sender], "Already subscribed");
        
        subscribers[msg.sender] = true;
        emit SubscriptionRenewed(msg.sender, block.timestamp);
    }

    function unsubscribe() external {
        require(subscribers[msg.sender], "Not subscribed");
        subscribers[msg.sender] = false;
    }

    function checkSubscriptionStatus(address _subscriber) external view returns (bool) {
        return subscribers[_subscriber];
    }

    function withdrawFunds() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}
