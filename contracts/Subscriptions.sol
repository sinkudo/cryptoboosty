// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "contracts/SubscriptionTiers.sol";

contract Subscriptions {
    SubscriptionTiers public subscriptionTiersInstance;

    uint nextId;
    // Оформление подписки
    // Request: [serverID, tierID, userID]
    // Response: [userID, roleID]

    struct Subscription {
        uint id;
        uint subscriptionTierId;
        uint startTimestamp;
        uint endTimestamp;
    }

    mapping (uint => Subscription[]) subscriptions;

    constructor(address subTiersAddress) {
        subscriptionTiersInstance = SubscriptionTiers(subTiersAddress);
    }

    function createSubscription(uint _serverId, uint _tierId, uint _userId) public returns (uint, uint) {
        SubscriptionTiers.SubscriptionTier memory tier = subscriptionTiersInstance.getById(_serverId, _tierId);

        Subscription memory newSub = Subscription({
            id: nextId,
            subscriptionTierId: _tierId,
            startTimestamp: block.timestamp,
            endTimestamp: block.timestamp + 30 days
        });
        subscriptions[_userId].push(newSub);
        nextId++;

        return (_userId, tier.roleId);
    }
}
