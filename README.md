# SIPmath : Calculating with Uncertainties

To get a better understanding of SIPmath, and the inspiration for this library, check out the Probability Management website at http://probabilitymanagement.org.

The ability to generate a stream of random numbers taken from a known distribution.

$$
P(E) = {n \choose k}
$$

Supports the following distributions:

  - Uniform
  - Normal
  - Beta

## Examples

    iex> _uniform_dist =
    ...>   with  name ="named dist",
    ...>         seed_value = 1
    ...>   do
    ...>     uniform(seed_value, name)
    ...>     |> SIPmath.stream()
    ...>     |> Enum.take(1)
    ...>   end
    [0.37674033659358525]

    iex> _combined_outcome =
    ...>   with  uniform_dist_1 = uniform(1, "value1"),
    ...>         uniform_dist_2 = uniform(2, "value2"),
    ...>         outcome_fun = fn {value1, value2} -> value1 + value2 end,
    ...>         trials = 1
    ...>   do
    ...>     [uniform_dist_1, uniform_dist_2]
    ...>     |> SIPmath.zip_map(outcome_fun, trials)
    ...>   end
    [0.8014632555662948]


## Usage

```elixir
def deps do
  [{:sipmath, "~> 0.1.0"}]
end
```
