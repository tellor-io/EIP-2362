# EIP-2362: Pull Oracle Interface

A standard interface for numeric pull oracles.

## Specification

In general there are two different types of oracles, push and pull oracles.
Where push oracles are expected to send back a response to the consumer and pull oracles allow consumers to pull or call/read the data onto their own systems.
This specification is for pull based oracles only.

### Definitions

<dl>
<dt>Oracle</dt>
<dd>An entity which reports data to the blockchain and it can be any Ethereum account.</dd>
<dt>Oracle consumer</dt>
<dd>A smart contract which receives or reads data from an oracle.</dd>
<dt>ID</dt>
<dd>A way of indexing the data which an oracle reports. May be derived from or tied to a question for which the data provides the answer.</dd>
<dt>Value</dt>
<dd>Data associated with an id which is reported by an oracle. This data oftentimes will be the answer to a question tied to the id. Other equivalent terms that have been used include: result, answer, data, outcome.</dd>
</dl>

### Pull-based Interface

The pull-based interface specs:

```solidity
interface Eip2362Oracle {
	function valueFor(bytes32 id) external view returns (uint timestamp, int value, int status);
}
```

- `valueFor` MUST return a status code of 404 if the value for an `id` is not available yet.
- Once a value is first available for an `id`, `valueFor` MUST return the value, along the timestamp representing when such value was set.
- May the value associated to an `id` be updated, `valueFor` MUST return the newest available value, along the timestamp representing when such update took place.

#### Inputs

##### `bytes32 id`

A standard descriptor of the data point we are querying a value for.

It is up to the implementor of an EIP-2362 compliant contract to decide which `id`s to support, i.e. for which `id`s will `valueFor` return a value and timestamp at some point, and for which it will always revert.

These `id`s MUST however be uniform across all providers: multiple EIP-2362 compliant contracts can give different values and timestamps for the same `id`, but they must be referring to the same data point.
	
Proposed Id generation fields: 
A complet list is kept on Google doc [here](https://docs.google.com/spreadsheets/d/15TPUuPWrxh7eMGaJKIupOh6l5yG-abn8UJejVhHCWV8/edit?usp=sharing).

| Description | ValuePair | DecimalPlaces | String           | Keccak256                                                        |
|-------------|-----------|---------------|------------------|------------------------------------------------------------------|
| Price       | USD/BTC   | 8             | Price-USD/BTC-8  | 2ecc80a3401165e1a04561d6ffe93662a31815d89cd63b00f248efd1cce47894 |
| Price       | USD/ETH   | 18            | Price-USD/ETH-18 | 28f03153ea1b458348adcbca7c93d5063b0bd35b469f55ba2a02bb7e598a09fd |
| Price       | EUR/ETH   | 18            | Price-EUR/ETH-18 | 4eed84fed518191e70583563ffc74c0c6de6c42b6692de62ef330718b389036d |
| Price       | EUR/BTC   | 8             | Price-EUR/BTC-8  | 97a6e43c73c50883d7b0a0f4e42c3f4de4af3ef8a8660471c89eb1ccf5416a92 |
| Price       | YEN/ETH   | 18            | Price-YEN/ETH-18 | 93c271043ed3be87a0480f8ebcbed7a550995d4908886e0ea0fe274e4e7c622c |
| Price       | YEN/BTC   | 8             | Price-YEN/BTC-8  | 1ef758ca57c8d37eebb8db6b6b4106aed0da20706ca6cc2cda56590847942062 |
| Price       | BTC/ETH   | 18            | Price-BTC/ETH-18 | ff146232e111e8d212b231c42ac6a77f8ce4e8e5a8350ca01803fc3cbdf948c0 |
| Price       | ETH/TRB   | 18            | Price-ETH/TRB-18 | fe5666d1fc5979be3be77f2cb0bd1ea6e2a8677318bf2479b3d694458b9794c5 |
| Price       | ETH/XMR   | 18            | Price-ETH/XMR-18 | f9bda91fcf6fa3ea13ed75b23dbbf88e8824f6672085fe75d99d224155bfba20 |
| Index       | S&P500    | 2             | Index-S&P500-2   | 99b7a28e618edb96c18e4a3b619daf28f99542787b6772dd7862c6e9bb9781d2 |

#### Outputs

##### `uint timestamp`

Timestamp (in the Unix format as used by the EVM) associated to the returned value.

It is up to the implementor of an EIP-2362 compliant contract to set the associated timestamp to one of these:
   - the timestamp of the block in which the returned value was last mutated (by invoking `block.timestamp` or `now()` at the updating transaction).
   - an oracle-specific timestamp that offers a more precise metric of when the reported value was actually probed.

##### `int value`

Latest value available for the requested `id`.

To accommodate for decimal values (which are common in prices and rates) this is expected to be multiplied by a power of ten such as `10**9` or `10**18`.
The specific power of ten MUST explicitly be stated by the `id` used as input.

##### `int status`

Describes the value's status. For consistency the statsus codes will corespond to the codes used for [HTTP](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) status codes 

Status codes: 
* 200 OK
* 400 Bad Request
* 404 Not Found


