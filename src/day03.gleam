import gleam/io
import gleam/result
import gleam/string
import gleam/list
import gleam/set
import gleam/map.{Map}
import gleam/int
import gleam/erlang/file

const items = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

fn calculate_item_priority() -> Map(String, Int) {
  items
    |> string.to_graphemes()
    |> list.index_map(fn(index, item) { #(item, index + 1) })
    |> map.from_list()
}

fn calculate_priority(line: String, item_priority: Map(String, Int)) -> Int {
  let graphemes = string.to_graphemes(line)
  let #(first, second) = list.split(graphemes, list.length(graphemes) / 2)

  let first_set = set.from_list(first)
  let second_set = set.from_list(second)

  let intersection = set.intersection(first_set, second_set)
  assert Ok(common_character) = intersection |> set.to_list() |> list.first()
  assert Ok(result) = item_priority |> map.get(common_character)

  result
}

pub fn run() {
  assert Ok(content) = file.read("input/day03.txt")
  let lines = content |> string.split("\n")

  let item_priority = calculate_item_priority()

  let priority_sum = lines
    |> list.filter(fn(line) { !string.is_empty(line) })
    |> list.map(fn(line) { calculate_priority(line, item_priority) } )
    |> int.sum

  io.println("[Day 3][Part 1] Priority sum: " <> int.to_string(priority_sum))
}

