"Evaluate the performance of the model using the test dataset.

Usage: src/04_results.R --output_path=<output_path>

Options:
--input_path_train=<input_path_train>
--input_path_test=<input_path_test>
--input_path_model=<input_path_model>
--output_path=<output_path>
" -> doc

library(docopt)
library(readr)
library(yardstick)
library(parsnip)

opt <- docopt::docopt(doc)

penguin_fit <- readr::read_rds(opt$output_path_model)
train_data <- readr::read_csv(opt$output_path_train)
test_data <- readr::read_csv(opt$output_path_test)

# Predict on test data
predictions <- parsnip::predict(penguin_fit, test_data, type = "class") %>%
  dplyr::bind_cols(test_data)

# Confusion matrix
conf_mat <- yardstick::conf_mat(predictions, truth = species, estimate = .pred_class)
conf_mat

# Save results
readr::write_rds(conf_mat, opt$output_path)