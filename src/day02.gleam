import gleam/io
import gleam/string
import gleam/int
import gleam/list
import gleam/erlang/file

type Choice {
  Rock
  Paper
  Scissors
}

type Outcome {
  Win
  Lose
  Draw
}

fn winning_choice(choice: Choice) -> Choice {
  case choice {
    Rock -> Paper
    Paper -> Scissors
    Scissors -> Rock
  }
}

fn losing_choice(choice: Choice) -> Choice {
  case choice {
    Rock -> Scissors
    Paper -> Rock
    Scissors -> Paper
  }
}

fn choice_to_score(choice: Choice) -> Int {
  case choice {
    Rock -> 1
    Paper -> 2
    Scissors -> 3
  }
}

fn outcome_to_score(outcome: Outcome) -> Int {
  case outcome {
    Win -> 6
    Lose -> 0
    Draw -> 3
  }
}

fn to_outcome(choices: #(Choice, Choice)) -> Outcome {
  case choices {
    #(Rock, Paper) | #(Paper, Scissors) | #(Scissors, Rock) -> Win
    #(Paper, Rock) | #(Scissors, Paper) | #(Rock, Scissors) -> Lose
    _ -> Draw
  }
}

fn parse_round_choices(line: String) -> Result(#(Choice, Choice), Nil) {
  let graphemes = string.to_graphemes(line)

  try first_char = graphemes |> list.at(0)
  try last_char = graphemes |> list.at(2)

  let opponent_choice = case first_char {
    "A" -> Rock
    "B" -> Paper
    "C" -> Scissors
  }
  let my_choice = case last_char {
    "X" -> Rock
    "Y" -> Paper
    "Z" -> Scissors
  }

  Ok(#(opponent_choice, my_choice))
}

fn parse_round_choice_and_outcome(line: String) -> Result(#(Choice, Outcome), Nil) {
  let graphemes = string.to_graphemes(line)

  try first_char = graphemes |> list.at(0)
  try last_char = graphemes |> list.at(2)

  let opponent_choice = case first_char {
    "A" -> Rock
    "B" -> Paper
    "C" -> Scissors
  }
  let my_choice = case last_char {
    "X" -> Lose 
    "Y" -> Draw
    "Z" -> Win
  }

  Ok(#(opponent_choice, my_choice))
}

fn calculate_round_choices(choices: #(Choice, Choice)) -> Int {
  let choice_score = choices.1 |> choice_to_score()
  let outcome_score = choices |> to_outcome() |> outcome_to_score()
  
  choice_score + outcome_score
}

fn calculate_round_choice_and_outcome(choices: #(Choice, Outcome)) -> Int {
  let choice_score = case choices {
    #(choice, Win) -> winning_choice(choice)
    #(choice, Lose) -> losing_choice(choice)
    #(choice, Draw) -> choice
  } |> choice_to_score()

  let outcome_score = choices.1 |> outcome_to_score()
  
  choice_score + outcome_score
}

pub fn run() {
  assert Ok(content) = file.read("input/day02.txt")
  let lines = content |> string.split("\n")
  
  let total_score_part_1 = lines
    |> list.filter(fn(line) { !string.is_empty(line) })
    |> list.filter_map(parse_round_choices)
    |> list.map(calculate_round_choices)
    |> int.sum()

  let total_score_part_2 = lines
    |> list.filter(fn(line) { !string.is_empty(line) })
    |> list.filter_map(parse_round_choice_and_outcome)
    |> list.map(calculate_round_choice_and_outcome)
    |> int.sum()

  io.println("[Day 2][Part 1] Total score: " <> int.to_string(total_score_part_1))
  io.println("[Day 2][Part 2] Total score: " <> int.to_string(total_score_part_2))
}

