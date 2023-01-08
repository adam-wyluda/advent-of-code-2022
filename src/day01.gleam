import gleam/io
import gleam/result
import gleam/string
import gleam/list
import gleam/int
import gleam/erlang/file

pub fn run() {
  assert Ok(content) = file.read("input/day01.txt")
  let lines =
    content
    |> string.split("\n")

  let calorie_groups =
    lines
    |> list.fold(
      [[]],
      fn(acc: List(List(Int)), el: String) {
        case el {
          "" -> [[], ..acc]
          calories -> {
            let value: Int = result.unwrap(int.parse(calories), 0)
            let first: List(Int) = result.unwrap(list.first(acc), [])
            let rest: List(List(Int)) = result.unwrap(list.rest(acc), [])
            [[value, ..first], ..rest]
          }
        }
      },
    )

  assert Ok(max_calorie_value) =
    calorie_groups
    |> list.map(int.sum)
    |> list.reduce(int.max)

  assert Ok(max_three_sum) =
    calorie_groups
    |> list.map(int.sum)
    |> list.sort(by: fn(a, b) { int.compare(b, a) })
    |> list.take(3)
    |> list.reduce(int.add)

  io.println("[Day 1][Part 1] Max value: " <> int.to_string(max_calorie_value))
  io.println(
    "[Day 1][Part 2] Sum of max three values: " <> int.to_string(max_three_sum),
  )
}
