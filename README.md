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
	function valueFor(bytes32 id) external view returns (uint timestamp, int value);
}
```

- `valueFor` MUST revert if the value for an `id` is not available yet.
- Once a value is first available for an `id`, `valueFor` MUST return the value, along the timestamp representing when such value was set.
- May the value associated to an `id` be updated, `valueFor` MUST return the newest available value, along the timestamp representing when such update took place.

#### Inputs

- `id`: Description of the required value. Should be standard between all providers. *Proposition:* use the `keccak256` hash of a string describing the requested pair*
	- keccak256("price-eth-usd") → 0x3d8553e168c60bf792b4d74a300ec5bb1d30bb361e76e6e0b718997770eba580
	- keccak256("price-btc-usd") → 0xaa42585bae5434c899dd8e4be37e1214661c793c1d1cc40a0ea63c9ef702517e
	- keccak256("price-eth-btc") → 0x1011b9dea6eedbcd54e76d64617d5ff8543929ae5322f839bad4c01007185505
	- ...

#### Outputs

- `timestamp`: Timestamp (in the unix format, with is used by the EVM), of the associated to the returned value.
- `value`: Latest value available for the requested `id`. To accomodate for decimal values (like prices) this should be multiplied by a big number such as `10**9` or `10**18`. This value should either be standardized as part of the EIP or be part of the `id` using format such as `keccak256("price-btc-usd-9")`.
