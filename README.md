# EIP-2362

Pull Oracle Interface

A standard interface for numeric pull oracles.

## Specification

In general there are two different types of oracles, push and pull oracles. Where push oracles are expected to send back a response to the consumer and pull oracles allow consumers to pull or call/read the data onto their own systems. This specification is for pull based oracles only.


Definitions


<dl>
<dt>Oracle</dt>
<dd>An entity which reports data to the blockchain and it can be any Ethereum account.</dd>
<dt>Oracle consumer</dt>
<dd>A smart contract which receives or reads data from an oracle.</dd>
<dt>ID</dt>
<dd>A way of indexing the data which an oracle reports. May be derived from or tied to a question for which the data provides the answer.</dd>
<dt>Result</dt>
<dd>Data associated with an id which is reported by an oracle. This data oftentimes will be the answer to a question tied to the id. Other equivalent terms that have been used include: answer, data, outcome.</dd>
<dt>Report</dt>
<dd>A pair (ID, result) which an oracle sends to an oracle consumer.</dd>
</dl>


### Pull-based Interface

The pull-based interface specs:

```solidity
interface Oracle {
function resultFor(bytes32 id) external view returns (uint timestamp, int outcome, int status);
}
```

`resultFor` MUST revert if the result for an `id` is not available yet.
`resultFor` MUST return the same result for an `id` after that result is available.
