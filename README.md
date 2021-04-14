# Solidity Games (Fun Repository)
A repository for Solidity-based smart contract games.

## 1. Maybe Doubler
*Logic:* Send ETH to the contract and either get double back (if the Unix block timestamp is an integer) or lose the bet (if the Unix block timestamp is odd). The assumption is that the contract is sufficiently funded by enough lost bets!
- Deployed Rinkeby Contract Address: [0xAaf7f03f027938D236C5C67e4417e605ADE2f32b](https://rinkeby.etherscan.io/address/0xaaf7f03f027938d236c5c67e4417e605ade2f32b)

## 2. Roulette
*Logic:*     
`BetTypes` are as follow:
- 0: color
- 1: column
- 2: dozen
- 3: eighteen
- 4: modulus
- 5: number

Depending on the `BetType`, number will be:
- color: 0 for black, 1 for red
- column: 0 for left, 1 for middle, 2 for right
- dozen: 0 for first, 1 for second, 2 for third
- eighteen: 0 for low, 1 for high
- modulus: 0 for even, 1 for odd
- number: number

The roulette just accepts a bet when has sufficient funds to pay for it and every other active bet. Also, different people can be playing at the same time.

One of the players will click the *"Spin Wheel"* button, which will generate a random number and all bets will be dealt with accordingly.

When a player wins a bet, the payout is credited on his personal account. The player can, at any moment, click the *"Cash out"* button and receive their winnings. Be advised that, at a particular moment, the roulette could have insufficient funds to pay winnings for all players. Continue reading to understand why this could happen.

- Deployed Rinkeby Contract Address: [0xcbcA57B53e130A5f172CAE7B0DA30655a60c5B4A](https://rinkeby.etherscan.io/address/0xcbca57b53e130a5f172cae7b0da30655a60c5b4a)
### Randomness
True randomness is not possible in the Ethereum Virtual Machine (EVM), due to the way the virtual machine operates. When a smart contract is called, every node in the network will have to run the code, to validate it, and at the end the state must be the same for every node (consensus). If, hypothetically, there would be a true random function available, then, when every node call it, it would spill a different value, making it impossible to achieve consensus.

So, we have to use the current state of the blockchain to find a fair random number, and the formula I choose was to calculate the hash of several factors, and use the reminder of the division of that hash by 37. The factors used in the hash are:
- The blockhash of the previous block
- The current block timestamp
- The current block difficulty
- The last accepted bet
> The problem with this approach is that everyone who can see the state of the blockchain, can calculate (*"guess"*) the future random number, and bet on that number.

### Security
So, the first security measure implemented was to make the random number dependable on the last bet. So, if for example, an attacker calculates that the random number will be 13, by betting on 13 he will change the outcome of the random number, making this type of attack ineffective.

But an attacker could make an inverted attack, by betting on a number and then waiting for the state of the blockchain to be one that generates that specific number. For this attack to work, the attacker must fulfill 2 conditions:
1. Be able to control when is the spin of the wheel;
2. Be able to accurately guess the next random number.

Condition one is difficult, because anyone can spin the wheel, but there will be times where the attacker will be the only one on the roulette, making it possible. With an average time per block of 14.4 seconds, and for a bet with a payout of 36, on average the attacker will have to be alone in the roulette for 37 * 14.4 / 60 ~= 9 minutes.

Condition two, is harder. Two of the factors used in calculating the *"random"* number refer to the current block, that will only be known with the spinning of the wheel, thus making it impossible to guess the “random” number. The problem is that, even unknown, the values of the current block timestamp and difficulty are strongly predictable, and even worse, can be manipulated by a miner.

In a nutshell, for a regular player will be very hard to guess the random number, but the system is vulnerable to attacks by miners. So additional security measures were put in place.

### Balance Cap
Every time the wheel is spinned, and all payouts credited in the players accounts, the system verifies if the roulette balance is higher than 2 ether. If so, it send the excess to the contract owner (me). This way, the maximum amount of ether an attacker could steal is of 3 ether (a full roulette with 2 ether, plus 100 bets of 0.01 ether).

Bear in mind that the personal accounts of players (their respective winnings) are not taking in consideration when calculating the balance. In other words, a player could have more than 2 ether in their winnings accounts, but be unable to cash out since the roulette hasn’t sufficient funds to pay.

This is intended to prevent a Denial of Service attack, where a player could have all the roulette money in his winnings account, preventing other players to play. It's players responsability to be aware of this, and cash out frequently.

**Have fun!**

## References
- https://github.com/bordalix/ethereum-roulette