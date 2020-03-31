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

##### `bytes32 id`

A standard descriptor of the data point we are querying a value for.

It is up to the implementor of an EIP-2362 compliant contract to decide which `id`s to support, i.e. for which `id`s will `valueFor` return a value and timestamp at some point, and for which it will always revert.

These `id`s MUST however be uniform across all providers: multiple EIP-2362 compliant contracts can give different values and timestamps for the same `id`, but they must be referring to the same data point.
	
**TODO:** The specifics of how to generate or agree on the `id` of a data point have not been specified yet.

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
