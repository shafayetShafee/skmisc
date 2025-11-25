test_that("is_bool_scalar() returns TRUE only for TRUE/FALSE scalars", {
  expect_true(is_bool_scalar(TRUE))
  expect_true(is_bool_scalar(FALSE))

  expect_false(is_bool_scalar(NA))
  expect_false(is_bool_scalar(c(TRUE, FALSE)))
  expect_false(is_bool_scalar("TRUE"))
  expect_false(is_bool_scalar(1L))
  expect_false(is_bool_scalar(NULL))
})

test_that("is_bool_scalar() interacts correctly with invalid inputs", {
  expect_false(is_bool_scalar(NULL))
  expect_false(is_bool_scalar(character(0)))
  expect_false(is_bool_scalar(list()))
})
