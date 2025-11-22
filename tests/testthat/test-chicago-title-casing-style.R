test_that("Chicago title casing: basic capitalization rules", {
  expect_equal(
    safe_title_case("a study on methods"),
    "{A Study on Methods}"
  )

  expect_equal(
    safe_title_case("understanding the effects of stress"),
    "{Understanding the Effects of Stress}"
  )

  expect_equal(
    safe_title_case("in the beginning"),
    "{In the Beginning}"
  )

  expect_equal(
    safe_title_case("a journey to the end"),
    "{A Journey to the End}"
  )

  expect_equal(
    safe_title_case("analysis of variance and its applications"),
    "{Analysis of Variance and Its Applications}"
  )
})


test_that("Chicago title casing: prepositions lowercased unless first/last", {
  expect_equal(
    safe_title_case("effects of light on growth"),
    "{Effects of Light on Growth}"
  )

  expect_equal(
    safe_title_case("in between worlds"),
    "{In Between Worlds}"
  )

  expect_equal(
    safe_title_case("toward a theory of everything"),
    "{Toward a Theory of Everything}"
  )

  expect_equal(
    safe_title_case("walking with the wind"),
    "{Walking with the Wind}"
  )

  expect_equal(
    safe_title_case("from here to there"),
    "{From Here to There}"
  )
})


test_that("Chicago title casing handles hyphenated words", {
  expect_equal(
    safe_title_case("long-term memory formation"),
    "{Long-Term Memory Formation}"
  )

  expect_equal(
    safe_title_case("state-of-the-art techniques"),
    "{State-of-the-Art Techniques}"
  )

  expect_equal(
    safe_title_case("cost-benefit analysis in practice"),
    "{Cost-Benefit Analysis in Practice}"
  )
})


test_that("Chicago title casing preserves acronyms", {
  expect_equal(
    safe_title_case("a study of NASA operations"),
    "{A Study of NASA Operations}"
  )

  expect_equal(
    safe_title_case("improving AI in medicine"),
    "{Improving AI in Medicine}"
  )

  expect_equal(
    safe_title_case("the role of DNA in evolution"),
    "{The Role of DNA in Evolution}"
  )
})


test_that("Chicago title casing preserves existing braces", {
  expect_equal(
    safe_title_case("a study of {NLP} methods"),
    "{A Study of {NLP} Methods}"
  )

  expect_equal(
    safe_title_case("analysis of {COVID-19} data"),
    "{Analysis of {COVID-19} Data}"
  )

  expect_equal(
    safe_title_case("understanding {GPU} computing"),
    "{Understanding {GPU} Computing}"
  )
})


test_that("Chicago title casing ignores protected braced segments", {
  expect_equal(
    safe_title_case("a study of {r and python} interoperability"),
    "{A Study of {r and python} Interoperability}"
  )

  expect_equal(
    safe_title_case("understanding {LaTeX} in practice"),
    "{Understanding {LaTeX} in Practice}"
  )
})

test_that("Chicago title casing trims whitespace safely", {
  expect_equal(
    safe_title_case("   a tale of two cities  "),
    "{A Tale of Two Cities}"
  )

  expect_equal(
    safe_title_case("\n\ton the origin of species "),
    "{On the Origin of Species}"
  )
})


test_that("Chicago title casing handles empty or invalid inputs", {
  expect_equal(safe_title_case(""), "{}")
  expect_equal(safe_title_case(NA_character_), "{}")
  expect_equal(safe_title_case(NULL), "{}")
})


test_that("Chicago title casing vectorization works", {
  input <- c(
    "a study on methods",
    "the history of AI",
    "walking with the wind"
  )

  expected <- c(
    "{A Study on Methods}",
    "{The History of AI}",
    "{Walking with the Wind}"
  )

  expect_equal(safe_title_case(input), expected)
})


test_that("Chicago rules for journal titles are respected", {
  expect_equal(
    safe_title_case("journal of statistical software"),
    "{Journal of Statistical Software}"
  )

  expect_equal(
    safe_title_case("annals of applied probability"),
    "{Annals of Applied Probability}"
  )

  expect_equal(
    safe_title_case("proceedings of the royal society"),
    "{Proceedings of the Royal Society}"
  )
})


test_that("Chicago rules for booktitle fields are respected", {
  expect_equal(
    safe_title_case("advances in data analysis"),
    "{Advances in Data Analysis}"
  )

  expect_equal(
    safe_title_case("handbook of machine learning"),
    "{Handbook of Machine Learning}"
  )
})


test_that("Chicago rules for manuscript titles are respected", {
  expect_equal(
    safe_title_case("rethinking deep learning optimization"),
    "{Rethinking Deep Learning Optimization}"
  )

  expect_equal(
    safe_title_case("analysis of bias in large datasets"),
    "{Analysis of Bias in Large Datasets}"
  )
})
